require 'test_helper'

class PostFlowTest < ActionController::IntegrationTest
  include Test::Integration::UserHelper

  fixtures :all
  set_fixture_class :user_password_resets => User::PasswordReset

  def setup
    remote_addr = '1.2.3.4'
    @forum = forums(:welcome)
  end 

  test "Posting a new topic" do
    with_login do |user|
      get new_forum_topic_path(@forum)
      assert_response :success

      post_via_redirect forum_topics_path(@forum), :topic => { :title => 'Hello world!', :body => 'Hi, how are you today?' }
      assert_response :success

      assert_select "tr#post_#{assigns(:topic).id}" do
        assert_select 'td.content div.user a', "#{user}"
        assert_select 'td.content div.body', /how are you today/
      end
    end
  end
end
