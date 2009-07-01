require 'test_helper'

class ForumsTest < ActionController::IntegrationTest
  include Test::Integration::UserHelper

  fixtures :all

  def setup
    remote_addr = '1.2.3.4'
  end 

  def test_read_forum
    with_login do
      assert_select "table.forums tr#forum_#{forums(:secret).id}" do
        assert_select '[class~=unread]'
      end

      get_via_redirect "/forums/#{forums(:secret)}/read"
      assert_equal '/forums', path

      assert_select "table.forums tr#forum_#{forums(:secret).id}" do
        assert_select '[class~=read]'
      end
    end
  end

  def test_read_all_forum
    with_login do
      assert_select 'table.forums tr.unread'

      get_via_redirect "/forums/read_all"
      assert_equal '/forums', path

      assert_select 'table.forums tr.unread', 0
      assert_select 'table.forums tr.read'
    end
  end

  def test_browse_forums
    with_login do
      assert_select 'table.forums .title a', 2 do |elements|
        elements.each do |link|
          get link['href']
          assert_response :success
          assert assigns(:topics)
        end
      end
    end
  end
end
