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

  def self.anonymous
    Rails.cache.fetch "Group:3", :expires_in => 10.minutes do
      find(3) || false
    end
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
    Rails.cache.fetch "Forum:#{forum_id}.Group:#{id}.rights", :expires_in => 10.minutes do
      rights.find_by_forum_id(forum_id, *args) || false
    end
  end
end

