require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_category
    assert_difference('Admin::Category.count') do
      post :create, :category => { }
    end

    assert_redirected_to category_path(assigns(:category))
  end

  def test_should_show_category
    get :show, :id => admin_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => admin_categories(:one).id
    assert_response :success
  end

  def test_should_update_category
    put :update, :id => admin_categories(:one).id, :category => { }
    assert_redirected_to category_path(assigns(:category))
  end

  def test_should_destroy_category
    assert_difference('Admin::Category.count', -1) do
      delete :destroy, :id => admin_categories(:one).id
    end

    assert_redirected_to admin_categories_path
  end
end
