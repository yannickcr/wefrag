require 'test_helper'

class UserTopicTimetrackTest < ActiveSupport::TestCase
  def setup
    @topic = posts(:topic1).becomes(Topic)
    @user  = users(:root)
  end

  def test_should_not_fail_with_string
    assert_nothing_raised 'Bad time value' do
      UserTopicTimetrack.track!(@user, @topic, 'bad value')
    end

    assert_equal @topic.time_spent_by(@user), 0, 'No time spent on topic'
  end

  def test_should_not_fail_with_negative
    assert_nothing_raised 'Negative time value' do
      UserTopicTimetrack.track!(@user, @topic, -13)
    end

    assert_equal @topic.time_spent_by(@user), 0, 'No time spent on topic'
  end

  def test_should_not_fail_with_decimal
    assert_nothing_raised 'Decimal time value' do
      UserTopicTimetrack.track!(@user, @topic, 12.17)
    end

    assert_equal @topic.time_spent_by(@user), 12, '12 seconds spent on topic'
  end

  def test_should_not_fail_with_big_value
    assert_nothing_raised 'Big value time value' do
      UserTopicTimetrack.track!(@user, @topic, 29494917)
    end

    assert_equal @topic.time_spent_by(@user), 3600, '1 hour spent on topic'
  end

  def test_should_success_with_time
    assert_nothing_raised 'Good time value' do
      UserTopicTimetrack.track!(@user, @topic, 47)
    end

    assert_equal @topic.time_spent_by(@user), 47, '1 hour spent on topic'
  end

  def test_should_success_with_multi_time
    times = [ 47, 31, 2 ]

    assert_nothing_raised 'Good time value' do
      times.each do |time|
        UserTopicTimetrack.track!(@user, @topic, time)
      end
    end

    assert_equal @topic.time_spent_by(@user), times.sum, "#{times.sum} seconds spent on topic"
  end
end 

