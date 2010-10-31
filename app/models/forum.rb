class Forum < ActiveRecord::Base
  default_scope :order => '`forums`.position ASC'
  acts_as_list :scope => :category

  belongs_to :category

  has_many :rights, :class_name => 'GroupForumRight'
  has_many :groups, :through => :rights

  has_many :posts, :include => :user
  has_many :topics, :conditions => '`posts`.topic_id IS NULL', :include => :user

  attr_accessible :title, :stripped_title

  validates_length_of :title, :in => 3..50
  validates_length_of :stripped_title, :in => 3..50
  validates_format_of :stripped_title, :with => /^([a-z0-9]+)(([a-z0-9_\-]+)?([a-z0-9]+))?$/

  def to_s
    "#{title}"
  end

  def last_post
    Rails.cache.fetch cache_key('last_post'), :expires_in => 1.hour do
      posts.oldest.last || false
    end
  end

  def to_param
    "#{stripped_title}"
  end

  def is_read_by?(user)
    return true unless user

    post = posts.first(
      :id,
      :joins => "LEFT OUTER JOIN `user_topic_reads` ON `user_topic_reads`.topic_id = IFNULL(`posts`.topic_id, `posts`.id) AND `user_topic_reads`.user_id = #{user.id}",
      :conditions => ['`posts`.created_at > ? AND (`user_topic_reads`.user_id IS NULL OR (`user_topic_reads`.is_forever = ? AND `user_topic_reads`.read_at < `posts`.created_at))', user.created_at, 0]
      )

    if post
      return false
    else
      return true
    end
  end

  # Misc
  def is_weplay?
    id == 7
  end

  # Rights
  def can_read?(user)
    has_rights?(user) do |rights|
      rights.is_read 
    end
  end

  def can_post?(user)
    has_rights?(user) do |rights|
      rights.is_post
    end
  end

  def can_moderate?(user)
    has_rights?(user)
  end

  def can_topic_moderate?(user)
    return false unless user && user.active?
    return false unless user.group_id && rights = user.forum_rights(id)
    rights.is_topic_moderate
  end

  def topics_count
    Rails.cache.fetch cache_key('topics_count'), :expires_in => 1.hour do
      topics.count
    end
  end

  def posts_count
    Rails.cache.fetch cache_key('posts_count'), :expires_in => 1.hour do
      posts.count
    end
  end

  protected

  def cache_key(data)
    "Forum(#{id}).at(#{(updated_at.to_i)}).#{data}"
  end

  def has_rights?(user)
    collection = user || Group.anonymous
    collection.has_rights?(id) do |rights|
      yield(rights) if block_given?
    end
  end
end
