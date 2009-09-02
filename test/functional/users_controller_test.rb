require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:joe)
    @pending_user = users(:pending)
  end 

  test 'on GET to :show' do
    get :show, { :id => @user.to_param }
    assert_response :success
    assert_template 'show'
  end
end
