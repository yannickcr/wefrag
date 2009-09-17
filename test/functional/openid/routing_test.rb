require File.dirname(__FILE__) + '/../../test_helper'

class OpenidRoutingTest < ActionController::TestCase
  tests OpenidController

  test 'route to :index' do
    assert_routing '/openid', { :controller => 'openid', :action => 'index' }
  end

  test 'route to :info' do
    assert_routing '/openid/xrds', { :controller => 'openid', :action => 'info', :format => 'xrds' }
  end

  test 'route to :decide' do
    assert_routing '/openid/decide', { :controller => 'openid', :action => 'decide' }
  end

  test 'helper to :index' do
    assert_equal '/openid', openid_server_path
  end

  test 'helper to :info' do
    assert_equal '/openid/xrds', openid_info_path
  end

  test 'helper to :decide' do
    assert_equal '/openid/decide', openid_decide_path
  end
end

