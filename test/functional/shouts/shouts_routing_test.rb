require File.dirname(__FILE__) + '/../../test_helper'

class ShoutRoutingTest < ActionController::TestCase
  tests ShoutsController

  def setup
    @page = '2'
  end 

  test 'route to :index' do
    assert_routing '/shouts', { :controller => 'shouts', :action => 'index' }
  end

  test 'route to :index with page' do
    assert_routing "/shouts/page/#{@page}", { :controller => 'shouts', :page => @page, :action => 'index' }
  end

  test 'route to :box' do
    assert_routing '/shouts/box', { :controller => 'shouts', :action => 'box' }
  end

  test 'route to :new' do
    assert_routing '/shouts/new', { :controller => 'shouts', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/shouts', :method => :post }, { :controller => 'shouts', :action => 'create' })
  end

  test 'helper to :index' do
    assert_equal '/shouts', shouts_path
  end

  test 'helper to :index with page' do
    assert_equal "/shouts/page/#{@page}", shouts_page_path(:page => @page)
  end

  test 'helper to :box' do
    assert_equal '/shouts/box', box_shouts_path
  end

  test 'helper to :new' do
    assert_equal '/shouts/new', new_shout_path
  end
end

