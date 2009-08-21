require File.dirname(__FILE__) + '/../../test_helper'

class SessionsRoutingTest < ActionController::TestCase
  tests SessionsController

  test 'route to :show' do
    assert_routing '/session', { :controller => 'sessions', :action => 'show' }
  end

  test 'route to :new' do
    assert_routing '/session/new', { :controller => 'sessions', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/session', :method => :post }, { :controller => 'sessions', :action => 'create' })
  end

  test 'route to :destroy' do
    assert_routing({ :path => '/session', :method => :delete }, { :controller => 'sessions', :action => 'destroy' })
  end

  test 'helper to :show' do
    assert_equal '/session', session_path
  end

  test 'helper to :new' do
    assert_equal '/session/new', new_session_path
  end
end

