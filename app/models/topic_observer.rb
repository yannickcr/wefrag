class TopicObserver < ActiveRecord::Observer
  def after_create(topic)
    topic.forum.topics_count(true)
  end
  def after_destroy(topic)
    topic.forum.topics_count(true)
  end
end

