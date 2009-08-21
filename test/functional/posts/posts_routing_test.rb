require File.dirname(__FILE__) + '/../../test_helper'

class PostsRoutingTest < ActionController::TestCase
  tests PostsController

  def setup
    @topic = posts(:topic1).becomes(Topic)
    @post = posts(:post10_12)
    @user = users(:joe)
  end 

  test 'route to :show' do
    assert_routing get_post_path(@post), get_post_params(@post).merge({ :action => 'show' })
  end

  test 'route to :quote' do
    assert_routing "#{get_post_path(@post)}/quote", get_post_params(@post).merge({ :action => 'quote' })
  end

  test 'route to :new' do
    assert_routing "#{get_posts_path(@topic)}/new", get_posts_params(@topic).merge({ :action => 'new' })
  end

  test 'route to :create' do
    assert_routing({ :path => get_posts_path(@topic), :method => :post }, get_posts_params(@topic).merge({ :action => 'create' }))
  end

  test 'route to :edit' do
    assert_routing "#{get_post_path(@post)}/edit", get_post_params(@post).merge({ :action => 'edit' })
  end

  test 'route to :update' do
    assert_routing({ :path => get_post_path(@post), :method => :put }, get_post_params(@post).merge({ :action => 'update' }))
  end

  test 'route to :destroy' do
    assert_routing({ :path => get_post_path(@post), :method => :delete }, get_post_params(@post).merge({ :action => 'destroy' }))
  end

  test 'helper to :show' do
    assert_equal get_post_path(@post), forum_topic_post_path(@post.forum, @post.topic, @post)
  end

  test 'helper to :quote' do
    assert_equal "#{get_post_path(@post)}/quote", quote_forum_topic_post_path(@post.forum, @post.topic, @post)
  end

  test 'helper to :new' do
    assert_equal "#{get_posts_path(@topic)}/new", new_forum_topic_post_path(@topic.forum, @topic)
  end

  test 'helper to :edit' do
    assert_equal "#{get_post_path(@post)}/edit", edit_forum_topic_post_path(@post.forum, @post.topic, @post)
  end

  private

  def get_post_path(post)
    "#{get_posts_path(post.topic)}/#{post.to_param}"
  end

  def get_posts_path(topic)
    "/forums/#{topic.forum.to_param}/topics/#{topic.to_param}/posts"
  end

  def get_post_params(post)
    get_posts_params(post.topic).merge({ :id => post.to_param })
  end

  def get_posts_params(topic)
    { :controller => 'posts', :forum_id => topic.forum.to_param, :topic_id => topic.to_param }
  end
end

