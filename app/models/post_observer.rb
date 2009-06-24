class PostObserver < ActiveRecord::Observer
  def after_create(post)
    post.topic.update_last_post_at
  end
  def after_destroy(post)
    post.topic.update_last_post_at
  end
end

