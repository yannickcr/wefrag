require File.dirname(__FILE__) + '/../../test_helper'

class SearchRoutingTest < ActionController::TestCase
  tests SearchController

  def setup
    @search = 'stuff'
    @page = '23'
  end

  test 'route to :show' do
    assert_routing "/search/#{@search}/#{@page}", { :controller => 'search', :action => 'show', :page => @page, :s => @search }
  end

  test 'route to :new' do
    assert_routing '/search', { :controller => 'search', :action => 'new' }
  end

  test 'route to :create' do
    assert_routing({ :path => '/search', :method => 'post' }, { :controller => 'search', :action => 'create' })
  end

  test 'helper to :show' do
    assert_equal "/search/#{@search}/#{@page}", search_path(@search, @page)
  end

  test 'helper to :new' do
    assert_equal '/search', new_search_path
  end

  test 'helper to :new (as :index)' do
    assert_equal '/search', searches_path
  end
end

