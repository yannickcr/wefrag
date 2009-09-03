class UserTopicRead < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  def has_read?(at)
    is_forever || read_at >= at
  rescue NoMethodError, ArgumentError
    false
  end

  def self.read_forever!(user, topic)
    connection.execute \
      "INSERT INTO `user_topic_reads` (user_id, topic_id, read_at, is_forever) " +
      "VALUES (#{user.id}, #{topic.id}, '#{topic.created_at.to_s(:db)}', 1) " +
      "ON DUPLICATE KEY UPDATE is_forever = IF(is_forever = 0, 1, 0)"
  end

  def self.read!(user, topic, read_at)
    if !(read = Rails.cache.read "UserTopicRead:#{user.id}:#{topic.id}") or read.read_at < read_at
      connection.execute \
        "INSERT INTO `user_topic_reads` (user_id, topic_id, read_at) " +
        "VALUES (#{user.id}, #{topic.id}, '#{read_at.to_s(:db)}') " +
        "ON DUPLICATE KEY UPDATE read_at = IF('#{read_at.to_s(:db)}' > read_at, '#{read_at.to_s(:db)}', read_at)"
    end
  end

  def self.read_forum!(user, forum)
    connection.execute \
      "INSERT INTO `user_topic_reads` (user_id, topic_id, read_at) " +
      "SELECT #{user.id}, p.id, p.last_post_at FROM `posts` p WHERE p.forum_id = #{forum.id} AND p.topic_id IS NULL " +
      "ON DUPLICATE KEY UPDATE `user_topic_reads`.read_at = p.last_post_at"
  end

  def self.read_forums!(user)
    forums    = user.readable_forums
    forum_ids = forums ? forums.collect { |r| r.id } : []

    unless forum_ids.empty?
      connection.execute \
        "INSERT INTO `user_topic_reads` (user_id, topic_id, read_at) " +
        "SELECT #{user.id}, p.id, p.last_post_at FROM `posts` p " +
        "WHERE p.forum_id IN (#{forum_ids.join(',')}) AND p.topic_id IS NULL " +
        "ON DUPLICATE KEY UPDATE `user_topic_reads`.read_at = p.last_post_at"
    end
  end
end
