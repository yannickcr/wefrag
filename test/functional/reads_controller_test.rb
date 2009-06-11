require File.dirname(__FILE__) + '/../test_helper'

class ReadsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:reads)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_read
    assert_difference('Read.count') do
      post :create, :read => { }
    end

    assert_redirected_to read_path(assigns(:read))
  end

  def test_should_show_read
    get :show, :id => reads(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => reads(:one).id
    assert_response :success
  end

  def test_should_update_read
    put :update, :id => reads(:one).id, :read => { }
    assert_redirected_to read_path(assigns(:read))
  end

  def test_should_destroy_read
    assert_difference('Read.count', -1) do
      delete :destroy, :id => reads(:one).id
    end

    assert_redirected_to reads_path
  end
end
