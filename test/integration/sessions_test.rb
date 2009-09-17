require 'test_helper'

class ForumsTest < ActionController::IntegrationTest
  include Test::Integration::UserHelper

  fixtures :all
  set_fixture_class :user_password_resets => User::PasswordReset

  def setup
    remote_addr = '1.2.3.4'
  end 

  def test_login
    login
    logout
  end

  def test_logout
    logout
  end
end
