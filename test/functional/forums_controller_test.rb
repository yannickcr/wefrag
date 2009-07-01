require File.dirname(__FILE__) + '/../test_helper'

class ForumsControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
  end 

  def test_should_get_home
    get :home
    assert @response.headers['X-XRDS-Location'], 'Found OpenId header'
    assert_redirected_to :action => :index
  end

  def test_should_get_index
    get :index
    assert @response.headers['X-XRDS-Location'], 'Found OpenId header'
    assert_response :success
    assert_select '.forums'
  end

  def test_should_show_missing_forum
    get :show, :id => 'unknown'
    assert_response :missing
  end

  def test_should_show_unauthorized_forum
    get :show, :id => "#{forums(:welcome)}"
    assert_redirected_to :controller => :sessions, :action => :new
  end

  def test_should_show_unauthorized_forum_with_page
    get :show, { :id => "#{forums(:secret)}", :page => 2 }
    assert_redirected_to :controller => :sessions, :action => :new
  end

  def test_should_show_forbidden_forum
    get :show, { :id => "#{forums(:welcome)}" }, { :user_id => users(:joe).id }
    assert_response 403
  end

  def test_should_show_forbidden_forum_with_page
    get :show, { :id => "#{forums(:secret)}", :page => 2 }, { :user_id => users(:joe).id }
    assert_response 403
  end

  def test_should_show_forum
    get :show, { :id => "#{forums(:welcome)}" }, { :user_id => users(:root).id }
    assert_response :success

    assert_select '.forum'
    assert_select 'link[type=?]', 'application/rss+xml'
  end

  def test_should_show_forum_with_page
    get :show, { :id => "#{forums(:welcome)}", :page => 1 }, { :user_id => users(:root).id }
    assert_response :success

    assert_select '.forum'

    get :show, { :id => "#{forums(:secret)}", :page => 2 }, { :user_id => users(:root).id }
    assert_response :success

    assert_select '.forum'
    assert_select '.pagination .current', 2
  end

  def test_should_show_forum_with_invalid_page
    get :show, { :id => "#{forums(:welcome)}", :page => 2 }, { :user_id => users(:root).id }
    assert_response :missing

    get :show, { :id => "#{forums(:secret)}", :page => 5 }, { :user_id => users(:root).id }
    assert_response :missing
  end

  def test_should_show_forum_rss
    get :show, { :id => "#{forums(:welcome)}", :format => :rss }, { :user_id => users(:root).id }
    assert_response :success
    assert_equal @response.content_type, Mime::RSS, 'Forum RSS is XML'
  end

  def test_should_show_forum_rss_with_page
    get :show, { :id => "#{forums(:secret)}", :format => :rss, :page => 2 }, { :user_id => users(:root).id }
    assert_response :success
    assert_equal @response.content_type, Mime::RSS, 'Forum RSS is XML'
  end

  def test_should_show_forum_rss_with_invalid_page
    get :show, { :id => "#{forums(:welcome)}", :format => :rss, :page => 2 }, { :user_id => users(:root).id }
    assert_response :missing
  end
end

