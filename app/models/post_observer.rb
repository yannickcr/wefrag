class PostObserver < ActiveRecord::Observer
  def after_create(post)
    post.topic.replies_count true
    post.topic.last_post true
    post.forum.posts_count true
    post.forum.last_post true

    post.topic.reload.reset_last_post_at
  end
  def after_destroy(post)
    unless post.is_topic?
      post.topic.replies_count true
      post.topic.last_post true
    end

    post.forum.posts_count true
    post.forum.last_post true

    post.topic.reload.reset_last_post_at unless post.is_topic?
  end
end

