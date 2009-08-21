require File.dirname(__FILE__) + '/../test_helper'

class OpenidControllerTest < ActionController::TestCase
  def setup
    @request.remote_addr = '1.2.3.4'

    @openid_params = {
      'openid.claimed_id' => 'http://specs.openid.net/auth/2.0/identifier_select',
      'openid.identity'   => 'http://specs.openid.net/auth/2.0/identifier_select',
      'openid.mode'       => 'checkid_setup',
      'openid.ns'         => 'http://specs.openid.net/auth/2.0',
      'openid.realm'      => 'http://example.com/openid',
      'openid.return_to'  => 'http://example.com/openid/complete'
    }
  end

  test 'on GET to :index' do
    get :index, @openid_params
    assert_redirected_to openid_decide_path(:req => encode(@openid_params))
  end

  test 'on GET to :info' do
    get :info, :format => 'xrds'

    assert_response :success
    assert_template 'info'
    assert_equal @response.content_type, Mime::XRDS
  end

  private

  def encode(params)
    OpenidController.encode_params(params)
  end
end

