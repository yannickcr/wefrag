class Group < ActiveRecord::Base
  has_many :users
  has_many :rights, :class_name => 'GroupForumRight' do
    def readable(options = {})
      f = []
      find_all_by_is_read(true, options).each do |r|
        f << r.forum
      end
      f
    end
  end

  attr_accessible :title
  validates_length_of :title, :in => 3..50

  def to_s
    "#{title}"
  end

  def self.get_cache(id)
    Rails.cache.fetch "Group(#{id})", :expires_in => 1.hour do
      find(id) rescue false
    end
  end

  def self.anonymous
    get_cache(3)
  end

  def readable_forums
    rights.readable
  end

  def has_rights?(forum_id)
    return false unless r = forum_rights(forum_id)
    r.is_moderate or block_given? && yield(r)
  end

  def forum_rights(forum, *args)
    forum_id = forum.is_a?(Forum) ? forum.id : forum
    Rails.cache.fetch "Group(#{id}).Forum(#{forum_id}).rights(#{(updated_at.to_i)})", :expires_in => 10.minutes do
      rights.find_by_forum_id(forum_id, *args) || false
    end
  end
end

