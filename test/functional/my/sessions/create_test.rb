require File.dirname(__FILE__) + '/../../../test_helper'

class My::SessionsCreateTest < ActionController::TestCase
  tests My::SessionsController

  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
  end

  test 'on POST to :create with unknown login' do
    post :create, { :login => 'some_unknown_login', :password => 'some password' }
    asset_new_form_has_errors
  end

  test 'on POST to :create with invalid password' do
    post :create, { :login => @user.login, :password => 'some invalid password' }
    asset_new_form_has_errors
  end

  test 'on POST to :create without login and password' do
    post :create
    asset_new_form_has_errors
  end

  private

  def asset_new_form_has_errors
    assert_response :success
    assert_template :new
    assert_select '.errorExplanation'
  end
end

