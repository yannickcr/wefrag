require File.dirname(__FILE__) + '/../../test_helper'

class User::PasswordControllerTest < ActionController::TestCase

  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
    @password_reset = user_password_resets(:joe_password_reset)
  end 

  test 'on GET to :index' do
    get :index

    assert_response :redirect
    assert_redirected_to new_user_password_url
  end

  test 'on GET to :new' do
    get :new

    assert_response :success
    assert_template :new

    assert_select 'form[action=?] input', user_password_index_path do
      assert_select '[name=?]', 'login_or_email'
    end
  end

  test 'on POST to :create with login' do
    assert_difference 'User::PasswordReset.count' do
      post :create, :login_or_email => @user.login
    end

    assert_create_success
  end

  test 'on POST to :create with email' do
    assert_difference 'User::PasswordReset.count' do
      post :create, :login_or_email => @user.email
    end

    assert_create_success
  end

  test 'on POST to :create with invalid user' do
    assert_no_difference 'User::PasswordReset.count' do
      post :create, :login_or_email => 'bad user'
    end

    assert_response :success
    assert_template :new
    assert_select '.errorExplanation'
  end

  test 'on GET to :show' do
    get :show, :id => @password_reset.code

    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /mot de passe.+généré/, flash[:notice]
  end

  test 'on GET to :show with bad code' do
    get :show, :id => '00ff44'

    assert_response :missing
  end

  private

  def assert_create_success
    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /confirmer.+nouveau mot de passe/, flash[:notice]
  end
end

