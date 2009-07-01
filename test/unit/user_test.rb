require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_should_be_passive
    assert users(:passive).passive?, 'User is not passive'
    assert !users(:passive).active?, 'User is active'
  end

  def test_should_be_active
    assert users(:joe).active?, 'User is not active'
    assert !users(:joe).passive?, 'User is passive'
  end

  def test_should_be_displayed_with_his_login
    assert_equal "#{users(:joe).login}", "#{users(:joe)}", 'User is displayed with his login'
  end

  def test_should_be_able_to_login
    assert users(:joe).can_login?, 'Active user can not login'
  end

  def test_should_not_be_able_to_login
    assert !users(:passive).can_login?, 'Passive user can login'
  end

  def test_should_register
    user = users(:passive)

    user.register!
    assert user.pending?, 'User is pending'
    assert !user.can_login?, 'User cannot login'

    user.notify!
    assert user.confirmed?, 'User is confirmed'
    assert user.can_login?, 'User can login'

    user.accept!
    assert user.accepted?, 'User is accepted'

    user.activate!
    assert user.active?, 'User is active'

    user.disable!
    assert user.disabled?, 'User is disabled'

    user.enable!
    assert user.active?, 'User is active (enabled back)'
  end

  def test_should_disable_and_enable
    user = users(:joe)
    user.disable!
    assert user.disabled?, 'User is disabled'

    user.enable!
    assert user.active?, 'User is active (enabled back)'
  end

  def test_should_cancel_registration
    user = users(:passive)

    user.register!
    assert user.pending?, 'User is pending'

    user.cancel!
    assert user.canceled?, 'User is canceled'
    assert user.frozen?, 'User is frozen'
  end
end 

