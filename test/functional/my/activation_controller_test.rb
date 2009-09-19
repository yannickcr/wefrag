require File.dirname(__FILE__) + '/../../test_helper'

class My::ActivationControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'
    @pending_user = users(:pending)
  end 

  test 'on GET to :show' do
    assert_difference 'User.pending.count', -1 do
      assert_difference 'User.confirmed.count' do
        get :show, { :id => @pending_user.confirmation_code }
      end
    end

    assert_response :redirect
    assert_redirected_to edit_user_url
    assert_equal @pending_user.id, session[:user_id]
    assert_match /confirmée/, flash[:notice]
  end
end
