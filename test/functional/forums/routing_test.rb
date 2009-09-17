require File.dirname(__FILE__) + '/../../test_helper'

class ForumsRoutingTest < ActionController::TestCase
  tests ForumsController

  def setup
    @forum = forums(:welcome)
    @user = users(:joe)
    @page = '2'
  end 

  test 'route to :home' do
    assert_routing '/', { :controller => 'forums', :action => 'home' }
  end

  test 'route to :index' do
    assert_routing '/forums', { :controller => 'forums', :action => 'index' }
  end

  test 'route to :show' do
    assert_routing "/forums/#{@forum.to_param}", { :controller => 'forums', :id => @forum.to_param, :action => 'show' }
  end

  test 'route to :show with page' do
    assert_routing "/forums/#{@forum.to_param}/#{@page}", { :controller => 'forums', :id => @forum.to_param, :page => @page, :action => 'show' }
  end

  test 'route to :read' do
    assert_routing "/forums/#{@forum.to_param}/read", { :controller => 'forums', :id => @forum.to_param, :action => 'read' }
  end

  test 'route to :read_all' do
    assert_routing "/forums/read_all", { :controller => 'forums', :action => 'read_all' }
  end

  test 'helper to :home' do
    assert_equal '/', root_path
  end

  test 'helper to :index' do
    assert_equal '/forums', forums_path
  end

  test 'helper to :show' do
    assert_equal "/forums/#{@forum.to_param}", forum_path(@forum)
  end

  test 'helper to :show with page' do
    assert_equal "/forums/#{@forum.to_param}/#{@page}", forum_path(@forum, :page => @page)
  end

  test 'helper to :read' do
    assert_equal "/forums/#{@forum.to_param}/read", read_forum_path(@forum)
  end

  test 'helper to :read_all' do
    assert_equal "/forums/read_all", read_all_forums_path
  end
end

