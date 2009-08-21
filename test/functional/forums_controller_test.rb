require File.dirname(__FILE__) + '/../test_helper'

class ForumsControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @forum = forums(:secret)
    @user = users(:root)
    @page = '2'
  end 

  test 'on GET to :home' do
    get :home

    assert_not_nil @response.headers['X-XRDS-Location']
    assert_response :redirect
    assert_redirected_to :action => :index
  end

  test 'on GET to :index' do
    get :index

    assert_not_nil @response.headers['X-XRDS-Location']
    assert_response :success
    assert_template 'index'
  end

  test 'on GET to :show' do
    get :show, { :id => @forum.to_param }, { :user_id => @user.id }

    assert assigns(:forum)
    assert_response :success
    assert_template 'show'
    assert_select 'link[type=?]', 'application/rss+xml'
  end

  test 'on GET to :show with page' do
    get :show, { :id => @forum.to_param, :page => @page }, { :user_id => @user.id }

    assert assigns(:forum)
    assert_response :success
    assert_template 'show'
    assert_select '.pagination .current', '2'
  end

  test 'on GET to :show as rss' do
    get :show, { :id => @forum.to_param, :format => 'rss' }, { :user_id => @user.id }

    assert_equal @response.content_type, Mime::RSS
    assert_response :success
    assert_template 'show'
  end
end

