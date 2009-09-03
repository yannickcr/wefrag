class Post < ActiveRecord::Base
  belongs_to :forum
  belongs_to :topic
  belongs_to :user

  named_scope :before, lambda { |post| {
    :conditions => [ '`posts`.created_at <= ?', post.created_at ]
  } }

  named_scope :for_topic, lambda { |topic| {
    :conditions => ['`posts`.topic_id = ? OR `posts`.id = ?', topic.id, topic.id ]
  } }

  named_scope :latest, :order => '`posts`.created_at DESC, `posts`.id DESC', :limit => 16


  is_indexed :fields => ['forum_id', 'created_at', 'title', 'body'],
             :include =>
             [
               { :association_name => 'user', :field => 'login', :as => 'user' },
               { :association_name => 'forum', :field => 'stripped_title', :as => 'forum' }
             ],
             :delta => true

  attr_accessible :body
  validates_length_of :body, :in => 3..60000 

  cattr_reader :per_page
  @@per_page = 25

  alias :real_topic :topic

  def title
    is_topic? ? read_attribute(:title) : ('Re : ' + topic.title)
  end

  def topic
    is_topic? ? becomes(Topic) : real_topic
  end

  def is_topic?
    topic_id.nil?
  end

  def is_locked?
    topic.is_locked
  end

  def is_sticky?
    topic.is_sticky
  end

  def page
    if is_topic?
      1
    else
      [topic.last_page, ((topic.replies.count(:conditions => [ 'posts.created_at <= ?', created_at ]) + 1).to_f / Post.per_page).ceil].min
    end
  end

  def move(forum)
    self.forum = forum
    save!
  end

  # Rights
  delegate :can_read?, :to => :forum

  def can_edit?(user)
    has_rights?(user) do |rights|
      return false if is_locked? || !user
        rights.is_edit && (user_id == user.id) && topic.user_infos.can_edit?(user)
    end
  end

  def can_delete?(user)
    has_rights?(user) do |rights|
      return false if is_locked? || !user
      (rights.is_topic_moderate && topic.user_id == user.id) or (rights.is_edit && (user_id == user.id) && topic.user_infos.can_edit?(user))
    end
  end

  def self.find_with_includes(id)
    find(id, :include => [:forum, :topic, :user])
  end

  def touch!
    update_attribute :updated_at, Time.now
  end

  protected

  def cache_key(data)
    "Post(#{id}).at(#{(updated_at.to_i)}).#{data}"
  end

  def has_rights?(user)
    collection = user || Group.anonymous
    collection.has_rights?(forum_id) do |rights|
      yield(rights) if block_given?
    end
  end
end
