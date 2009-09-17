require 'test_helper'

class PasswordResetTest < ActionController::IntegrationTest
  include Test::Integration::UserHelper

  fixtures :all
  set_fixture_class :user_password_resets => User::PasswordReset

  def setup
    remote_addr = '1.2.3.4'
    @user = users(:root)
  end 

  def test_new_password
    get_via_redirect '/user/session'
    assert_response :success
    assert_select 'a[href=?]', new_user_password_path

    get '/user/password/new'
    assert_select 'input[name=login_or_email]'

    post '/user/password', :login_or_email => @user.login
    assert_response :redirect
    assert_redirected_to forums_url

    password_reset = assigns(:password_reset)

    get "/user/password/#{password_reset.code}" 
    assert_response :redirect
    assert_redirected_to forums_url

    user = assigns(:user)

    login(@user.login, user.password)
  end
end
