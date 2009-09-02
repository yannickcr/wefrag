require 'test_helper'

class ShoutTest < ActiveSupport::TestCase
  def test_should_not_save_shout_without_user
    shout = Shout.new(:body => 'Some text') do |s|
      s.ip_address = '1.2.3.4'
    end

    assert !shout.save, 'Shout saved without user'
  end

  def test_should_not_save_shout_without_body
    shout = Shout.new do |s|
      s.user = users(:joe)
      s.ip_address = '1.2.3.4'
    end

    assert !shout.save, 'Shout saved without body'
  end

  def test_should_not_save_shout_with_empty_body
    shout = Shout.new(:body => '') do |s|
      s.user = users(:joe)
      s.ip_address = '1.2.3.4'
    end

    assert !shout.save, 'Shout saved with empty body'
  end

  def test_should_not_save_shout_with_too_long_body
    shout = Shout.new(:body => 'some text' * 100) do |s|
      s.user = users(:joe)
      s.ip_address = '1.2.3.4'
    end

    assert !shout.save, 'Shout saved with too long body'
  end

  def test_should_save_shout
    shout = Shout.new(:body => 'some text') do |s|
      s.user = users(:joe)
      s.ip_address = '1.2.3.4'
    end

    assert shout.save, 'Shout not saved'
  end

  def test_should_show_json
    shouts = Shout.all.to_json
    assert_not_equal shouts, '', 'Shouts json is not empty'

    assert_nothing_raised 'Shouts json is not valid' do
      shouts = ActiveSupport::JSON.decode(shouts)
    end

    assert_operator shouts.size, :>, 0, 'No json entries returned'

    shouts.each do |shout|
      assert_equal shout.keys, ['shout']
      assert_equal shout['shout'].keys.sort, ['body', 'created_at', 'user']
    end
  end

  def test_should_paginate
    assert_operator Shout.paginate(:page => 1).size, :==, 50
  end
end 

