class TopicObserver < ActiveRecord::Observer
  def after_save(topic)
    topic.forum.touch!
  end

  def after_update(topic)
    Forum.find(topic.forum_id_was).touch! if topic.forum_id_changed?
  end

  def after_destroy(topic)
    topic.forum.touch!
  end
end

