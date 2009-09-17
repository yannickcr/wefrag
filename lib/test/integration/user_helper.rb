module Test
  module Integration
    module UserHelper
      private

      def with_login
        login
        yield users(:root)
        logout
      end

      def login(login = 'root', password = 'root')
        get '/session/new'
        assert_response :success

        post_via_redirect '/session', :login => login, :password => password
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

