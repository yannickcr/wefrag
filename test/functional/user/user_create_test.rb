require File.dirname(__FILE__) + '/../../test_helper'

class UserCreateTest < ActionController::TestCase
  tests UserController

  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
  end 

  test 'on POST to :create with existing login' do
    assert_no_difference 'User.count' do
      post :create, :user => { :login => @user.login, :email => 'somenew@example.com' }
    end

    asset_new_form_has_errors
  end

  test 'on POST to :create with existing e-mail' do
    assert_no_difference 'User.count' do
      post :create, :user => { :login => 'bobby', :email => @user.email }
    end

    asset_new_form_has_errors
  end

  test 'on POST to :create without login and password' do
    assert_no_difference 'User.count' do
      post :create
    end

    asset_new_form_has_errors
  end

  private

  def asset_new_form_has_errors
    assert_response :success
    assert_template :new
    assert_select '.errorExplanation'
  end
end

