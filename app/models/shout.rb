class Shout < ActiveRecord::Base
  belongs_to :user

  attr_accessible :body
  validates_length_of :body, :in => 1..250

  named_scope :latest, :include => :user, :order => '`shouts`.created_at DESC'

  cattr_reader :per_page
  @@per_page = 50

  # Rights
  def can_edit?(user)
    user and user.is_admin 
  end

  def can_delete?(user)
    can_edit?
  end

  def to_json(options = {})
    options.reverse_merge!(:only => [ :created_at, :body ], :include => { :user => { :only => :login } })
    super(options)
  end
end
