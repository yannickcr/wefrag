require File.dirname(__FILE__) + '/../../test_helper'

class Admin::GroupsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_group
    assert_difference('Admin::Group.count') do
      post :create, :group => { }
    end

    assert_redirected_to group_path(assigns(:group))
  end

  def test_should_show_group
    get :show, :id => admin_groups(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_groups(:one).id
    assert_response :success
  end

  def test_should_update_group
    put :update, :id => admin_groups(:one).id, :group => { }
    assert_redirected_to group_path(assigns(:group))
  end

  def test_should_destroy_group
    assert_difference('Admin::Group.count', -1) do
      delete :destroy, :id => admin_groups(:one).id
    end

    assert_redirected_to admin_groups_path
  end
end
