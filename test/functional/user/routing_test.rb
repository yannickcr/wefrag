require File.dirname(__FILE__) + '/../../test_helper'

class UserRoutingTest < ActionController::TestCase
  tests UserController

  def setup
    @confirmation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end 

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

  test 'route to :confirm' do
    assert_routing "/user/#{@confirmation_code}", { :controller => 'user', :action => 'confirm', :code => @confirmation_code }
  end

  test 'route to :cancel' do
    assert_routing "/user/#{@confirmation_code}/cancel", { :controller => 'user', :action => 'cancel', :code => @confirmation_code }
  end

  test 'helper to :show' do
    assert_equal '/user', user_path
  end

  test 'helper to :new' do
    assert_equal '/user/new', new_user_path
  end

  test 'helper to :confirm' do
    assert_equal "/user/#{@confirmation_code}", confirm_user_path(@confirmation_code)
  end

  test 'helper to :cancel' do
    assert_equal "/user/#{@confirmation_code}/cancel", cancel_user_path(@confirmation_code)
  end
end

