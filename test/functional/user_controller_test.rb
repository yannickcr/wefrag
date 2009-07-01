require File.dirname(__FILE__) + '/../test_helper'

class UserControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
  end 

  def test_should_get_new
    get :new
    assert_response :success

    assert_select 'form[action=?] input', user_path do
      assert_select '[name=?]', 'user[login]'
      assert_select '[name=?]', 'user[email]'
    end
  end

  def test_should_create_user
    assert_difference('User.count') do
      post :create, :user => { :login => 'bob', :email => 'bob@example.com' }
    end

    assert_redirected_to :controller => :forums, :action => :index#forums_url

    assert_equal "#{User.find_by_login('bob')}", 'bob'
    assert_match /mail.+confirmer.+inscription/, flash[:notice] 
  end

  def test_should_show_user
    user = create_user
    user.notify!

    get :show, nil, { :user_id => user.id }
    assert_redirected_to :action => :edit#forums_url
  end

  def test_should_get_edit
    user = create_user
    user.notify!

    get :edit, nil, { :user_id => user.id }
    assert_response :success
  end

  def test_should_destroy_user
    user = create_user
    user.notify!

    assert_difference('User.count', -1) do
      delete :destroy, nil, { :user_id => user.id }
    end

    assert_redirected_to :controller => :forums, :action => :index#forums_url

    assert !User.exists?(user.id), 'User doesn\'t exist anymore'
    assert_match /supprimé/, flash[:notice] 
  end

  def test_should_confirm_user
    user = create_user
    get :confirm, { :code => user.confirmation_code }

    assert_redirected_to :action => :edit#forums_url

    assert user.reload.confirmed?, 'User is confirmed'
    assert_match /confirmée.+identifié.+compte.+actif/, flash[:notice] 
  end

  private

  def create_user(login = 'ken', email = 'ken@example.com')
    user = User.create! do |u|
      u.login = login
      u.email = email
    end
    user.register!
    user
  end
end
