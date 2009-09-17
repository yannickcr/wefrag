require File.dirname(__FILE__) + '/../../test_helper'

class UsersRoutingTest < ActionController::TestCase
  tests UsersController

  def setup
    @user = users(:joe)
  end

  test 'route to :show' do
    assert_routing "/users/#{@user.to_param}", { :controller => 'users', :action => 'show', :id => @user.to_param }
  end

  test 'helper to :show' do
    assert_equal "/users/#{@user.to_param}", show_user_path(@user)
  end
end

