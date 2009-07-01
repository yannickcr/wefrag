require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
  end 

  def test_should_route_to_show
    assert_routing('session', { :controller => 'sessions', :action => 'show' }, { }, { }, 'Route "session" not found')
  end

  def test_should_route_to_new
    assert_routing('session/new', { :controller => 'sessions', :action => 'new' }, { }, { }, 'Route "session/new" not found')
  end

  def test_should_route_to_create
    assert_routing({ :method => :post, :path => 'session' }, { :controller => 'sessions', :action => 'create' }, { }, { }, 'Route create "session" not found')
  end

  def test_should_route_to_destroy
    assert_routing({ :method => :delete, :path => 'session' }, { :controller => 'sessions', :action => 'destroy' }, { }, { }, 'Route destroy "session" not found')
  end

  def test_should_get_show
    get :show
    assert_redirected_to :action => :new
  end

  def test_should_get_new
    get :new
    assert_response :success

    assert_select 'form[action=?] input', session_path do
      assert_select '[name=?]', 'login'
      assert_select '[name=?]', 'password'
    end
  end

  def test_should_get_new_as_js
    get :new, :format => 'js'
    assert_response :success

    assert_equal @response.content_type, Mime::JS
    assert_no_tag :tag => 'html'

    assert_tag :tag => 'form', :attributes => { :action => session_path }
    assert_tag :tag => 'input', :attributes => { :name => 'login' }
    assert_tag :tag => 'input', :attributes => { :name => 'password' }
  end

  def test_should_create_session
    login('joe', 'joe')
    assert_redirected_to :controller => :forums, :action => :index

    assert_equal @response.session[:user_id], users(:joe).id
    assert_match /identifié/, flash[:notice] 
  end

  def test_should_create_session_with_invalid_password
    [ 'joe ', '', 'joe someveryveryveryveryveryverylong data', ' joe', 'anything', 'joe*', '%joe', '%', '--', '*' ].each do |password|
      login('joe', password)
      assert_response :success, "Password #{password} is invalid for #{users(:joe).login} login"
      assert_select '.errorExplanation', /passe.+incorrect/
    end
  end

  def test_should_create_session_with_invalid_login
    [ 'john', 'joe*', '%joe', '%', '--', '*' ].each do |login|
      login(login, 'joe')
      assert_response :success, "Login #{login} is invalid"
      assert_select '.errorExplanation', /passe.+incorrect/
    end
  end

  def test_should_destroy_session
    login('joe', 'joe')
    assert_equal @response.session[:user_id], users(:joe).id

    delete :destroy
    assert_redirected_to :controller => :forums, :action => :index#forums_url
    assert_nil @response.session[:user_id], 'User id removed from session'
  end

  private

  def login(user, password)
    post :create, { :login => user, :password => password }
  end
end

