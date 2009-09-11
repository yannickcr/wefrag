require 'test_helper'

class UserTopicTimetrackTest < ActiveSupport::TestCase
  def test_should_not_fail_with_string
    assert_nothing_raised 'Bad time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 'bad value')
    end
  end

  def test_should_not_fail_with_negative
    assert_nothing_raised 'Negative time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), -13)
    end
  end

  def test_should_not_fail_with_decimal
    assert_nothing_raised 'Decimal time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 12.17)
    end
  end

  def test_should_not_fail_with_big_value
    assert_nothing_raised 'Big value time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 29494917)
    end
  end

  def test_should_success_with_time
    assert_nothing_raised 'Good time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 47)
    end
  end

  def test_should_success_with_multi_time
    assert_nothing_raised 'Good time value' do
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 47)
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 31)
      UserTopicTimetrack.track!(users(:root), topics(:topic_1), 2)
    end
  end
end 

