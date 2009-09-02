class TopicObserver < ActiveRecord::Observer
  def after_create(topic)
    topic.update_attribute(:last_post_at, topic.created_at)
  end

  def after_update(topic)
    Forum.find(topic.forum_id_was).touch if topic.forum_id_changed?
  rescue ActiveRecord::RecordNotFound
    #
  end
end

