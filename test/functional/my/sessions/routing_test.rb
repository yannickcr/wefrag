require File.dirname(__FILE__) + '/../../../test_helper'

class My::SessionsRoutingTest < ActionController::TestCase
  tests My::SessionsController

  test 'route to :show' do
    assert_routing '/my/session', { :controller => 'my/sessions', :action => 'show' }
  end

  test 'route to :new' do
    assert_routing '/my/session/new', { :controller => 'my/sessions', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/my/session', :method => :post }, { :controller => 'my/sessions', :action => 'create' })
  end

  test 'route to :destroy' do
    assert_routing({ :path => '/my/session', :method => :delete }, { :controller => 'my/sessions', :action => 'destroy' })
  end

  test 'helper to :show' do
    assert_equal '/my/session', my_session_path
  end

  test 'helper to :new' do
    assert_equal '/my/session/new', new_my_session_path
  end
end

