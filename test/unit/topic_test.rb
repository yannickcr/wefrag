require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def test_should_set_last_past_at_when_created
    topic = forums(:secret).topics.new do |t|
      t.user = users(:joe)
      t.ip_address = '1.2.3.4'
      t.title = 'Hello world'
      t.body = 'Some random message'
    end

    assert topic.save, 'Topic saved'
    assert_not_nil topic.created_at, 'Set topic created_at'
    assert_equal topic.last_post_at, topic.created_at, 'Topic last date is topic creation date'
  end
end 

