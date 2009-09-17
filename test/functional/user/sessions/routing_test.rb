require File.dirname(__FILE__) + '/../../../test_helper'

class User::SessionsRoutingTest < ActionController::TestCase
  tests User::SessionsController

  test 'route to :show' do
    assert_routing '/user/session', { :controller => 'user/sessions', :action => 'show' }
  end

  test 'route to :new' do
    assert_routing '/user/session/new', { :controller => 'user/sessions', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/user/session', :method => :post }, { :controller => 'user/sessions', :action => 'create' })
  end

  test 'route to :destroy' do
    assert_routing({ :path => '/user/session', :method => :delete }, { :controller => 'user/sessions', :action => 'destroy' })
  end

  test 'helper to :show' do
    assert_equal '/user/session', user_session_path
  end

  test 'helper to :new' do
    assert_equal '/user/session/new', new_user_session_path
  end
end

