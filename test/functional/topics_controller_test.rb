require File.dirname(__FILE__) + '/../test_helper'

class TopicsControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'

    @forum = forums(:welcome)
    @topic = posts(:topic1).becomes(Topic)
    @user  = users(:root)
  end 

  test "Should show a topic" do
    get :show, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }
    assert_response :success

    assert_select "tr#post_#{@topic.id}"
  end

  test "Should show a sticky topic" do
    @topic = posts(:sticky_topic).becomes(Topic)

    get :show, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }
    assert_response :success

    assert_select "div.header .actions .sticky"
  end

  test "Should show a locked topic" do
    @topic = posts(:locked_topic).becomes(Topic)

    get :show, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }
    assert_response :success

    assert_select "div.header .actions .locked"
  end

  test "Should show a new topic" do
    get :new, { :forum_id => "#{@forum.to_param}" }, { :user_id => @user.id }
    assert_response :success

    assert_select 'form[action=?]', forum_topics_path(@forum) do
      assert_select 'input[name=?]', 'topic[title]'
      assert_select 'textarea[name=?]', 'topic[body]'
    end
  end

  test "Should create a topic" do
    data = { :title => 'Hellow world!', :body => 'Hi, how are you today?' }
    assert_difference 'Topic.find_all_by_topic_id(nil).count' do
      post :create, { :forum_id => "#{@forum.to_param}", :topic => data }, { :user_id => @user.id }
    end
    
    topic = assigns(:topic)

    assert_equal @user.id, topic.user.id
    assert_equal @forum.id, topic.forum.id
    assert_equal data[:title], topic.title
    assert_equal data[:body], topic.body
    assert_match /sujet(.+)créé/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should edit a topic" do
    get :edit, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }
    assert_response :success

    topic = assigns(:topic)

    assert_select 'form[action=?]', forum_topic_path(topic.forum, topic) do
      assert_select 'input[name=?]', 'topic[title]'
      assert_select 'textarea[name=?]', 'topic[body]'
    end
  end

  test "Should update a topic" do
    data = { :title => 'My friend!', :body => 'We are still friends.' }
    post :update, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :topic => data }, { :user_id => @user.id }
    
    topic = assigns(:topic)

    assert_equal data[:title], topic.title
    assert_equal data[:body], topic.body
    assert_match /sujet(.+)mis à jour/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should delete a topic" do
    assert_difference 'Topic.find_all_by_topic_id(nil).count', -1 do
      assert_difference 'Post.count', -@topic.posts_count do
        delete :destroy, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }
      end
    end

    topic = assigns(:topic)

    assert_match /sujet(.+)supprimé/, flash[:notice]
    assert_redirected_to forum_path(topic.forum)
  end

  test "Should lock a topic" do
    post :lock, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert topic.is_locked?
    assert_match /\sverrouillé/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should unlock a topic" do
    @topic = posts(:locked_topic).becomes(Topic)
   
    post :lock, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert !topic.is_locked?
    assert_match /\sdéverrouillé/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should stick a topic" do
    post :stick, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert topic.is_sticky?
    assert_match /important/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should unstick a topic" do
    @topic = posts(:sticky_topic).becomes(Topic)
   
    post :stick, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert !topic.is_sticky?
    assert_match /normal/, flash[:notice]

    assert_redirected_to forum_topic_path(topic.forum, topic)
  end

  test "Should move a topic" do
    assert_no_difference 'Topic.count' do
      post :move, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}", :topic => { :forum_id => "#{@forum.id}" } }, { :user_id => @user.id }
    end

    topic = assigns(:topic)

    assert_equal @forum.id, topic.forum.id
    assert_redirected_to forum_path(topic.forum)
  end

  test "Should read a topic" do
    get :read, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert topic.is_read_by?(@user)
    assert_redirected_to forum_path(topic.forum)
  end

  test "Should read forever a topic" do
    get :read_forever, { :forum_id => "#{@topic.forum.to_param}", :id => "#{@topic.to_param}" }, { :user_id => @user.id }

    topic = assigns(:topic)

    assert topic.is_read_by?(@user)
    assert topic.is_read_forever_by?(@user)
    assert_redirected_to forum_path(topic.forum)
  end

  test "Should ban an user from a topic" do
  end

  test "Should unban an user from a topic" do
  end
end

