require File.dirname(__FILE__) + '/../../../test_helper'

class My::PasswordRoutingTest < ActionController::TestCase
  tests My::PasswordController

  def setup
    @code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end 

  test 'route to :index' do
    assert_routing "/my/password", { :controller => 'my/password', :action => 'index' }
  end

  test 'route to :show' do
    assert_routing "/my/password/#{@code}", { :controller => 'my/password', :action => 'show', :id => @code }
  end

  test 'route to :new' do
    assert_routing '/my/password/new', { :controller => 'my/password', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/my/password', :method => :post }, { :controller => 'my/password', :action => 'create' })
  end

  test 'helper to :index' do
    assert_equal "/my/password", my_password_index_path
  end

  test 'helper to :show' do
    assert_equal "/my/password/#{@code}", my_password_path(@code)
  end

  test 'helper to :new' do
    assert_equal '/my/password/new', new_my_password_path
  end
end

