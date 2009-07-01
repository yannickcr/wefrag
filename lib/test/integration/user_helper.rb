module Test
  module Integration
    module UserHelper
      private

      def with_login(&block)
        login
        yield(block)
        logout
      end

      def login
        get '/session/new'
        assert_response :success

        post_via_redirect '/session', :login => users(:root).login, :password => 'root'
        assert_equal '/forums', path
        assert_match /maintenant identifié/, flash[:notice]
      end

      def logout
        delete_via_redirect '/session'
        assert_equal '/forums', path
        assert_match /plus identifié/, flash[:notice]
      end
    end
  end
end

