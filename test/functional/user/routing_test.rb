require File.dirname(__FILE__) + '/../../test_helper'

class UserRoutingTest < ActionController::TestCase
  tests UserController

  test 'route to :show' do
    assert_routing '/user', { :controller => 'user', :action => 'show' }
  end

  test 'route to :new' do
    assert_routing '/user/new', { :controller => 'user', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/user', :method => :post }, { :controller => 'user', :action => 'create' })
  end

  test 'route to :edit' do
    assert_routing '/user/edit', { :controller => 'user', :action => 'edit' }
  end

  test 'route to :update' do
    assert_routing({ :path => '/user', :method => :put }, { :controller => 'user', :action => 'update' })
  end

  test 'route to :destroy' do
    assert_routing({ :path => '/user', :method => :delete }, { :controller => 'user', :action => 'destroy' })
  end

  test 'helper to :show' do
    assert_equal '/user', user_path
  end

  test 'helper to :new' do
    assert_equal '/user/new', new_user_path
  end
end

