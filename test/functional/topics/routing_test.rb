require File.dirname(__FILE__) + '/../../test_helper'

class TopicsRoutingTest < ActionController::TestCase
  tests TopicsController

  def setup
    @forum = forums(:welcome)
    @topic = posts(:topic1).becomes(Topic)
    @user = users(:joe)
  end 

  test 'route to :show' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}", { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'show' }
  end

  test 'route to :quote' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/quote", { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'quote' }
  end

  test 'route to :move' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/move", { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'move' }
  end

  test 'route to :read' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/read", { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'read' }
  end

  test 'route to :read_forever' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/read_forever", { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'read_forever' }
  end

  test 'route to :stick' do
    assert_routing({ :path => "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/stick", :method => :post }, { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'stick' })
  end

  test 'route to :lock' do
    assert_routing({ :path => "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/lock", :method => :post }, { :controller => 'topics', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :action => 'lock' })
  end

  test 'route to :new' do
    assert_routing "/forums/#{@forum.to_param}/topics/new", { :controller => 'topics', :forum_id => "#{@forum.to_param}", :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :method => :post, :path => "/forums/#{@topic.forum.to_param}/topics" }, { :controller => 'topics', :action => 'create', :forum_id => "#{@topic.forum.to_param}" })
  end

  test 'route to :edit' do
    assert_routing "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/edit", { :controller => 'topics', :action => 'edit', :forum_id => @topic.forum.to_param, :id => @topic.to_param }
  end

  test 'route to :update' do
    assert_routing({ :method => :put, :path => "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}" }, { :controller => 'topics', :action => 'update', :forum_id => @topic.forum.to_param, :id => @topic.to_param })
  end

  test 'route to :destroy' do
    assert_routing({ :method => :delete, :path => "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}" }, { :controller => 'topics', :action => 'destroy', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" })
  end

  test 'route to :ban' do
    assert_routing({ :path => "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/ban/#{@user.id}", :method => :post }, { :controller => 'topics', :action => 'ban', :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :user_id => "#{@user.id}" })
  end

  test 'route to :timetrack' do
    assert_routing({ :method => :post, :path => "/topics/#{@topic.to_param}/timetrack" }, { :controller => 'topics', :action => 'timetrack', :id => "#{@topic.to_param}" })
  end

  test 'helper to :show' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}", forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :quote' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/quote", quote_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :move' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/move", move_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :read' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/read", read_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :read_forever' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/read_forever", read_forever_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :stick' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/stick", stick_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :lock' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/lock", lock_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :new' do
    assert_equal "/forums/#{@forum.to_param}/topics/new", new_forum_topic_path(@forum)
  end

  test 'helper to :edit' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/edit", edit_forum_topic_path(@topic.forum, @topic)
  end

  test 'helper to :ban' do
    assert_equal "/forums/#{@topic.forum.to_param}/topics/#{@topic.to_param}/ban/#{@user.id}", ban_forum_topic_path(@topic.forum, @topic, @user.id)
  end

  test 'helper to :timetrack' do
    assert_equal "/topics/#{@topic.to_param}/timetrack", timetrack_topic_path(@topic)
  end
end

