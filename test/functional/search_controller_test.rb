require File.dirname(__FILE__) + '/../test_helper'

class SearchControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @search = 'cool'
  end 

  test 'on GET to :new' do
    get :new

    assert_response :success
    assert_template 'new'
  end

  test 'on POST to :create' do
    post :create, { :s => @search }

    assert_response :redirect
    assert_redirected_to :action => :show, :s => escape(@search)
  end

  test 'on POST to :create with empty search' do
    post :create

    assert_response :success
    assert_template 'new'
  end

  test 'on GET to :show' do
    get :show, { :s => escape(@search) }

    assert_response :success
    assert_template 'show'
  end

  private

  def escape(param)
    URI.escape(param)
  end
end

