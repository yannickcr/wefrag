require File.dirname(__FILE__) + '/../test_helper'

class UserControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
    @pending_user = users(:pending)
  end 

  test 'on GET to :show' do
    get :show, nil, { :user_id => @user.id }
    assert_response :redirect
    assert_redirected_to :action => :edit
  end

  test 'on GET to :new' do
    get :new

    assert_response :success
    assert_template 'new'

    assert_select 'form[action=?] input', user_path do
      assert_select '[name=?]', 'user[login]'
      assert_select '[name=?]', 'user[email]'
    end
  end

  test 'on POST to :create' do
    assert_difference 'User.pending.count' do
      post :create, :user => { :login => 'example', :email => 'example@example.com' }
    end

    assert user = assigns(:user)
    assert 'example',             user.login
    assert 'example@example.com', user.email

    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /confirmer votre inscription/, flash[:notice]
  end

  test 'on GET to :edit' do
    get :edit, nil, { :user_id => @user.id }

    assert_response :success
    assert_template 'edit'

    assert_select 'form[action=?] input', user_path
  end

  test 'on PUT to :update' do
    put :update, { :user => { :first_name => 'John', :last_name => 'Doe' } }, { :user_id => @user.id }

    assert user = assigns(:user)
    assert 'John', user.first_name
    assert 'Doe',  user.first_name

    assert_response :redirect
    assert_redirected_to :action => :edit
    assert_match /mis à jour/, flash[:notice]
  end

  test 'on DELETE to :destroy' do
    assert_difference 'User.count', -1 do
      delete :destroy, nil, { :user_id => @user.id }
    end

    assert !User.exists?(@user.id)
    assert_nil session[:user_id]

    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /supprimé/, flash[:notice]
  end

  test 'on GET to :confirm' do
    assert_difference 'User.pending.count', -1 do
      assert_difference 'User.confirmed.count' do
        get :confirm, { :code => @pending_user.confirmation_code }
      end
    end

    assert_response :redirect
    assert_redirected_to :action => :edit
    assert_equal session[:user_id], @pending_user.id
    assert_match /confirmée/, flash[:notice]
  end

  test 'on GET to :cancel' do
    assert_difference 'User.count', -1 do
      get :cancel, { :code => @pending_user.confirmation_code }
    end

    assert_response :redirect
    assert_redirected_to forums_path
    assert_match /annulée/, flash[:notice]
  end
end
