require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ForumsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_forums)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_forum
    assert_difference('Admin::Forum.count') do
      post :create, :forum => { }
    end

    assert_redirected_to forum_path(assigns(:forum))
  end

  def test_should_show_forum
    get :show, :id => admin_forums(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_forums(:one).id
    assert_response :success
  end

  def test_should_update_forum
    put :update, :id => admin_forums(:one).id, :forum => { }
    assert_redirected_to forum_path(assigns(:forum))
  end

  def test_should_destroy_forum
    assert_difference('Admin::Forum.count', -1) do
      delete :destroy, :id => admin_forums(:one).id
    end

    assert_redirected_to admin_forums_path
  end
end
