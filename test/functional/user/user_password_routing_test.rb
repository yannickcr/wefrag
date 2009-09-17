require File.dirname(__FILE__) + '/../../test_helper'

class UserPasswordRoutingTest < ActionController::TestCase
  tests User::PasswordController

  def setup
    @code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end 

  test 'route to :index' do
    assert_routing "/user/password", { :controller => 'user/password', :action => 'index' }
  end

  test 'route to :show' do
    assert_routing "/user/password/#{@code}", { :controller => 'user/password', :action => 'show', :id => @code }
  end

  test 'route to :new' do
    assert_routing '/user/password/new', { :controller => 'user/password', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/user/password', :method => :post }, { :controller => 'user/password', :action => 'create' })
  end

  test 'helper to :index' do
    assert_equal "/user/password", user_password_index_path
  end

  test 'helper to :show' do
    assert_equal "/user/password/#{@code}", user_password_path(@code)
  end

  test 'helper to :new' do
    assert_equal '/user/password/new', new_user_password_path
  end
end

