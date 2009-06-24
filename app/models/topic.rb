class Topic < Post
  default_scope :conditions => '`posts`.topic_id IS NULL', :order => '`posts`.is_sticky DESC, `posts`.last_post_at DESC, `posts`.created_at DESC, `posts`.id DESC'

  has_many :user_infos, :class_name => 'UserTopicInfo' do
    def can_reply?(user)
      return true unless user
      Rails.cache.fetch "UserTopicInfo:#{user.id}:#{proxy_owner.id}", :expires_in => 1.second do
        if info = find_by_user_id(user.id)
          info.is_reply
        else
          true
        end
      end
    end
    alias :can_edit?   :can_reply?
    alias :can_delete? :can_reply?
  end

  has_many :reads, :class_name => 'UserTopicRead' do
    def for_user(user)
      return false unless user
      Rails.cache.fetch "UserTopicRead:#{user.id}:#{proxy_owner.id}", :expires_in => 1.second do
        find_by_user_id(user.id) || false
      end
    end
  end

  has_many :replies, :class_name => 'Post',
                     :order      => '`posts`.created_at DESC',
                     :include    => :user

  attr_accessible :title
  validates_length_of :title, :in => 3..100

  def to_s
    "#{title}"
  end

  def topic
    self
  end

  def pages_count
    (posts_count.to_f / Post.per_page).ceil
  end

  alias :last_page :pages_count

  def posts
    forum.posts.for_topic(self)
  end

  def is_read_by?(user, post = nil)
    return true unless user
    created_at = post ? post.created_at : last_post.created_at

    if read = reads.for_user(user)
      read.has_read?(created_at)
    else
      user.created_at > created_at
    end
  end

  def is_read_forever_by?(user, post = nil)
    return true unless user
    created_at = post ? post.created_at : last_post_at
    read = reads.for_user(user) and read.is_forever
  end

  def first_unread_by(user)
    if read = reads.for_user(user) and !read.is_forever
      replies.find :first, :include => [], :conditions => ['created_at > ?', read.read_at.to_s(:db)], :order => 'created_at ASC', :limit => 1
    end
  end

  def ban!(user)
    info = user_infos.find_or_create_by_user_id(user.id)
    info.toggle!(:is_reply)
    info
  end

  def move(forum_id)
    Topic.transaction do
      forum = Forum.find(forum_id)
      super(forum)
      replies.each { |p| p.move(forum) }
      return true
    end
    false
  end

  # Rights
  def can_reply?(user)
    has_rights?(user) do |rights|
      return false unless !is_locked? && user
      rights.is_reply && ((user_id == user.id && rights.is_topic_moderate) || user_infos.can_reply?(user))
    end
  end

  def can_lock?(user)
    has_rights?(user) do |rights|
      return false unless user
      user_id == user.id && rights.is_topic_moderate
    end
  end

  alias :can_ban? :can_lock?

  def replies_count(force = false)
    Rails.cache.fetch "Topic:#{id}.replies_count", :expires_in => 1.day, :force => force do
      replies.count
    end
  end

  def posts_count(force = false)
    replies_count(force) + 1
  end

  def last_post(force = false)
    Rails.cache.fetch "Topic:#{id}.last_post", :expires_in => 1.day, :force => force do
      replies.first || Topic.find_by_id(self.id) || false
    end
  end

  def reset_last_post_at
    update_attribute(:last_post_at, last_post.created_at)
  end
end
