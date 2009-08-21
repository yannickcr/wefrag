class PostObserver < ActiveRecord::Observer
  def after_create(post)
    post.topic.update_last_post_at unless post.is_topic?
  end

  def after_update(post)
    unless post.is_topic?
      post.topic.touch!
      Topic.find(post.topic_id_was).touch! if post.topic_id_changed?
    end
  end

  def after_destroy(post)
    post.topic.update_last_post_at unless post.is_topic?
  end
end

