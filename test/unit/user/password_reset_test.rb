require 'test_helper'

class User::PasswordResetTest < ActiveSupport::TestCase
  def setup
    @user = users(:joe)
    @password_reset = user_password_resets(:joe_password_reset)
  end

  def test_should_request_new_password
    pr = @user.request_new_password!
    assert_equal :sent, pr.state, 'User new password request sent'
  end

  def test_should_confirm_new_password_request
    assert_equal :sent, @password_reset.state, 'Request in sent state'

    user = @password_reset.user
    old_crypted_password = user.crypted_password

    @password_reset.confirm!

    assert_equal :changed, @password_reset.state, 'Request in changed state'
    assert @password_reset.frozen?, 'Request in frozen'

    assert_not_equal '', user.password, 'New password set'
    assert_not_equal old_crypted_password, user.crypted_password, 'Crypted password changed'

    assert_not_nil User.authenticate(user.login, user.password), 'Can authenticate with new password'
  end
end 

