module AuthenticatedSystem
  protected

  def authenticate(login, password)
    if self.current_user = User.authenticate(login, password)
      current_user
    end
  end

  def unauthenticate
    reset_session
  end

  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user
  end

  def authorized?(action = nil, resource = nil, *args)
    logged_in?
  end

  # Accesses the current user from the session.  Set it to :false if login fails
  # so that future calls do not hit the database.
  def current_user
    unless defined?(@current_user)
      if @current_user = login_from_session || login_from_basic_auth
        @current_user = nil unless @current_user.can_login?
      end
    end
    @current_user
  end

  # Store the given user id in the session.
  def current_user=(user)
    session[:user_id] = (user.nil? || user.is_a?(Symbol)) ? nil : user.id
    @current_user = user
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    #self.current_user = User.find_by_id_with_group(session[:user_id]) if session[:user_id]
    self.current_user = User.auth_by_id(session[:user_id]) if session[:user_id]
  end


  def login_from_basic_auth
    return nil unless request.ssl?
    authenticate_with_http_basic do |username, password|
      User.authenticate(username, password)
    end
  end
end
