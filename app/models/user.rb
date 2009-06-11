require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :openid_trusts, :class_name => 'UserOpenidTrust'
  has_many :tokens, :class_name => 'OauthToken',
                    :order      => 'authorized_at DESC',
                    :include    => :client_application

  belongs_to :group

  has_one :info, :class_name => 'UserInfo'

  delegate :rights, :to => :group
  delegate :forum_rights, :to => :group

  has_many :topics
  has_many :posts
  has_many :reads, :class_name => 'UserTopicRead'
  has_many :topic_infos, :class_name => 'UserTopicInfo' do
    def can_reply?(topic, *args)
      !(info = find_by_topic_id(topic.id, *args)) or info.is_reply
    end
    alias :can_edit? :can_reply?
  end

  belongs_to :image

  named_scope :active,  :conditions => { :state => 'active' }
  named_scope :pending, :conditions => { :state => 'pending' }
  named_scope :authenticatable, :conditions => { :state => ['confirmed', 'active' ] }

  named_scope :address, :select => 'users.city, users.country',
              :conditions => "users.city IS NOT NULL AND users.city != '' AND users.country IS NOT NULL AND users.country != ''"

  @@countries = ['France', 'Belgique', 'Suisse', 'Canada', 'Etats-Unis', 'Autre']
  @@states = { :passive => 'Créé', :pending => 'En attente', :notified => 'Informé', :confirmed => 'Confirmé',
               :accepted => 'Accepté', :refused => 'Refusé', :active => 'Activé', :disabled => 'Désactivé' }

  def self.countries
    @@countries
  end

  def self.states
    @@states
  end

  attr_accessor :password, :previous_password
  attr_accessible # none

  validates_presence_of   :login, :email
  validates_length_of     :login, :within => 3..20
  validates_length_of     :email, :within => 3..200
  validates_format_of     :login, :with   => /^([a-zA-Z0-9_\-]+)$/i, :on => :create
  validates_uniqueness_of :login, :email, :case_sensitive => false

  validates_presence_of     :password,                :if => :password_required?
  validates_presence_of     :password_confirmation,   :if => :password_required?, :on => :update
  validates_confirmation_of :password,                :if => :password_required?, :on => :update
  validates_length_of       :password, :minimum => 4, :if => :password_required?, :on => :update
  validates_presence_of     :previous_password,       :if => :password_required?, :on => :update

  validates_length_of :first_name, :maximum => 100, :allow_blank => true, :allow_nil => true
  validates_length_of :last_name,  :maximum => 100, :allow_blank => true, :allow_nil => true
  validates_length_of :city,       :maximum => 50,  :allow_blank => true, :allow_nil => true
  validates_length_of :country,    :maximum => 50,  :allow_blank => true, :allow_nil => true

  validates_inclusion_of :state,   :in => self.states
  validates_inclusion_of :country, :in => self.countries, :allow_nil => true, :allow_blank => true

  validates_date :birthdate, :allow_nil => true, :message => 'n\'est pas une date correcte'
  validates_email_format_of :email, :message => ' ne semble pas être une adresse e-mail valide.'

  before_validation_on_create :set_random_password
  before_create               :make_confirmation_code
  before_save                 :encrypt_password

  # State machine
  acts_as_state_machine :initial => :passive
  state :passive
  state :pending
  state :notified,  :after => :confirm!
  state :confirmed
  state :canceled,  :after => :destroy
  state :accepted
  state :refused
  state :active,    :enter => :do_activate, :after => :after_activate
  state :disabled

  event :register do
    transitions :from => :passive, :to => :pending
  end

  event :notify do
    transitions :from => :pending, :to => :notified
  end

  event :confirm do
    transitions :from => :notified, :to => :confirmed
    transitions :from => :pending, :to => :confirmed
  end

  event :cancel do
    transitions :from => :notified, :to => :canceled
    transitions :from => :pending, :to => :canceled
  end

  event :accept do
    transitions :from => :confirmed, :to => :accepted
  end

  event :refuse do
    transitions :from => :confirmed, :to => :refused
  end

  event :activate do
    transitions :from => :accepted, :to => :active
  end
  
  event :disable do
    transitions :from => :active, :to => :disabled
  end
  
  event :enable do
    transitions :from => :disabled, :to => :active
  end

  def validate_on_update
    errors.add_to_base('Ancien mot de passe incorrect') unless !password_required? || authenticated?(previous_password)
  end

  def to_s
    "#{login}"
  end

  def to_param
    @string = URI.escape(to_s)
  end

  def address
    [ city, country ].reject{ |x| x.empty? }.join(', ')
  end

  def self.find_by_param(login)
    find_by_login(URI.unescape(login))
  end

  def has_email_alias?
    active? and !info || info.is_email
  end

  def email_alias
    "#{to_s.downcase}@wefrag.com"
  end

  def openid_identity
    "http://www.wefrag.com/users/#{to_param}"
  end

  def attributes_from_input=(data)
    self.city    = data[:city]
    self.country = data[:country]

    if confirmed?
      self.first_name = data[:first_name]
      self.last_name  = data[:last_name]
      self.birthdate  = { :year => data[:'birthdate(1i)'], :month => data[:'birthdate(2i)'], :day => data[:'birthdate(3i)'] }
    elsif active?
      self.password              = data[:password]
      self.password_confirmation = data[:password_confirmation]
      self.previous_password     = data[:previous_password]
    end
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    if u = authenticatable.find_by_login(login) and u.authenticated?(password)
      u
    else
      nil
    end
  end

  def self.find_by_openid(identity)
    if match = identity.match(/^http:\/\/www\.wefrag\.com\/users\/([a-zA-Z0-9_\-]+)$/)
      find_by_param(match[1])
    else
      nil
    end
  end

  # Authenticates a user by their openid identity and unencrypted password.  Returns the user or nil.
  def self.authenticate_from_openid(identity, password)
    if u = authenticable.find_by_openid(identity)
      u
    else
      nil
    end
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  # User rights
  def can_login?
    confirmed? or active?
  end

  def can_admin?
    active? and is_admin
  end

  def image_code
    confirmation_code[0..4].upcase unless confirmation_code.nil?
  end

  def is_underage?
    !birthdate or ((Date.today.strftime("%Y%m%d").to_i - birthdate.strftime("%Y%m%d").to_i) / 10000).to_i < 18
  end

  def age
    if birthdate
      ((Date.today.strftime("%Y%m%d").to_i - birthdate.strftime("%Y%m%d").to_i) / 10000).to_i
    end
  end

  def is_complete?
    [:first_name, :last_name, :city, :country, :birthdate, :image_id].each do |attribute|
      return false if self[attribute].nil? || self[attribute].to_s.empty?
    end
    true
  end

  def is_banned?(topic)
    (topic.user_id != id) && !topic_infos.can_reply?(topic)
  end

  def has_rights?(forum_id)
    return false unless active?
    return true  if     is_admin
    return false unless group_id
    if block_given?
      group.has_rights?(forum_id) do |rights|
        yield(rights)
      end
    else
      group.has_rights?(forum_id)
    end
  end

  def destroy
    image.destroy if image
    super
  end

  def birthdate=(value)
    if value.is_a?(Hash)
      begin
        value = Date.parse([ value[:year], value[:month], value[:day] ].join('-')).to_s(:db)
      rescue ArgumentError
        value = nil
      end
    end
    write_attribute :birthdate, value
  end

  def readable_forums
    if is_admin
      Forum.find :all
    elsif group
      group.readable_forums
    end
  end

  def self.auth_by_id(id)
    get_cache(id)
  end

  def self.get_cache(id)
    Rails.cache.fetch "User:#{id}", :expires_in => 1.hour do
      find_by_id(id) || false
    end
  end

  def reset_cache
    Rails.cache.write "User:#{id}", self.reload, :expires_in => 1.hour
  end

  def expire_cache
    Rails.cache.delete "User:#{id}"
  end

  protected

  def do_activate
    self.confirmation_code = nil
  end

  def after_activate
    image.destroy if image
  end

  def set_random_password
    self.password = Password.generate(10, Password::ONE_DIGIT)
  end

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end
    
  def password_required?
    crypted_password.blank? or !password.blank?
  end
  
  def make_confirmation_code
    self.confirmation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
