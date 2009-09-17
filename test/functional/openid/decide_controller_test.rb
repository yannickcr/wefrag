require File.dirname(__FILE__) + '/../../test_helper'

class OpenidDecideControllerTest < ActionController::TestCase
  tests OpenidController

  def setup
    @request.remote_addr = '1.2.3.4'
    @user = users(:root)

    @openid_params = {
      'openid.claimed_id' => 'http://specs.openid.net/auth/2.0/identifier_select',
      'openid.identity'   => 'http://specs.openid.net/auth/2.0/identifier_select',
      'openid.mode'       => 'checkid_setup',
      'openid.ns'         => 'http://specs.openid.net/auth/2.0',
      'openid.realm'      => 'http://example.com/openid',
      'openid.return_to'  => 'http://example.com/openid/complete'
    }
  end

  test 'on GET to :decide' do
    get :decide, :req => encode(@openid_params)

    assert_response :success
    assert_template 'auth_and_decide'

    assert_select 'form[action=?] input', openid_decide_path(:req => encode(@openid_params)) do
      assert_select '[name=?]', 'login'
      assert_select '[name=?]', 'password'
    end
  end

  test 'on GET to :decide with authenticated user' do
    get :decide, { :req => encode(@openid_params) }, { :user_id => @user.id }

    assert user = assigns(:user)
    assert_equal @user.id, user.id

    assert_response :success
    assert_template 'decide'

    assert_select 'form[action=?]', openid_decide_path(:req => encode(@openid_params))
  end

  test 'on POST to :decide' do
    assert_difference 'UserOpenidTrust.count' do
      post :decide, { :req => encode(@openid_params) }, { :user_id => @user.id }
    end

    assert_response :redirect
    assert_match @openid_params['openid.return_to'], @response.redirected_to
    assert_match 'openid.mode=id_res', @response.redirected_to
  end

  test 'on POST to :decide with authenticated user' do
    assert_difference 'UserOpenidTrust.count' do
      post :decide, { :req => encode(@openid_params) }, { :user_id => @user.id }
    end

    assert_response :redirect
    assert_match @openid_params['openid.return_to'], @response.redirected_to
    assert_match 'openid.mode=id_res', @response.redirected_to
  end

  test 'on POST refuse to :decide' do
    assert_no_difference 'UserOpenidTrust.count' do
      post :decide, { :refuse => '', :req => encode(@openid_params), :login => @user.login, :password => 'root' }
    end

    assert_response :redirect
    assert_match @openid_params['openid.return_to'], @response.redirected_to
    assert_match 'openid.mode=cancel', @response.redirected_to
  end

  test 'on POST refuse to :decide with authenticated user' do
    assert_no_difference 'UserOpenidTrust.count' do
      post :decide, { :refuse => '', :req => encode(@openid_params) }, { :user_id => @user.id }
    end

    assert_response :redirect
    assert_match @openid_params['openid.return_to'], @response.redirected_to
    assert_match 'openid.mode=cancel', @response.redirected_to
  end

  private

  def encode(params)
    OpenidController.encode_params(params)
  end
end

