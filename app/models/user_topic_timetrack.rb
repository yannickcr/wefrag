class UserTopicTimetrack < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  named_scope :for_user, lambda { |user| { :conditions => { :user_id => user.id } } }

  def self.track!(user, topic, time)
    connection.execute \
      "INSERT INTO `user_topic_timetracks` (user_id, topic_id, spent, tracked_at) " +
      "VALUES (#{user.id}, #{topic.id}, LEAST(GREATEST(#{time.to_i}, 0), 3600), DATE_FORMAT('#{Time.now.to_s(:db)}', '%Y-%m-%d %H:00:00')) " +
      "ON DUPLICATE KEY UPDATE spent = LEAST(spent + VALUES(spent), 3600)"
  rescue NoMethodError, ArgumentError
    # Ignore
  end
end
