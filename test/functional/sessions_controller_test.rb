require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
  end

  test 'on GET to :show' do
    get :show
    assert_response :redirect
    assert_redirected_to new_session_path
  end

  test 'on GET to :new' do
    get :new

    assert_response :success
    assert_template 'new'

    assert_select 'form[action=?] input', session_path do
      assert_select '[name=?]', 'login'
      assert_select '[name=?]', 'password'
    end
  end

  test 'on GET to :new as javascript' do
    get :new, :format => 'js'

    assert_response :success
    assert_template 'new'
    assert_equal @response.content_type, Mime::JS

    assert_no_tag :tag => 'html'
    assert_tag :tag => 'form', :attributes => { :action => session_path }
    assert_tag :tag => 'input', :attributes => { :name => 'login' }
    assert_tag :tag => 'input', :attributes => { :name => 'password' }
  end

  test 'on POST to :create' do
    post :create, { :login => @user.login, :password => 'joe' }

    assert_response :redirect
    assert_redirected_to forums_path
    assert_equal session[:user_id], @user.id
    assert_match /maintenant identifié/, flash[:notice]
  end

  test 'on DELETE to :destroy' do
    delete :destroy, nil, { :user_id => @user.id }

    assert_nil session[:user_id]
    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /plus identifié/, flash[:notice]
  end
end

