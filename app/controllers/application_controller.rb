class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  protect_from_forgery
  filter_parameter_logging :password

  helper :all

  append_before_filter :set_default_url_options_for_mailers


  def self.exceptions_to_treat_as_404
    exceptions = [ActiveRecord::RecordNotFound,
                  ActionController::UnknownController,
                  ActionController::UnknownAction]
    exceptions << ActionController::RoutingError if ActionController.const_defined?(:RoutingError)
    exceptions << WillPaginate::InvalidPage      if defined?(WillPaginate)
    exceptions
  end

  def set_default_url_options_for_mailers
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def has_feed
    @has_feed = true
  end

  # HTTP errors
  def forbidden
    if logged_in?
      render :text => 'forbidden', :status => 403
    else
      flash[:notice] = 'Vous devez être identifié pour accéder à cette page'
      redirect_to new_my_session_url
    end
    false
  end

  def notfound
    render :text => 'notfound' and return false
  end

  # Model loading
  def load_forum
    key = is_a?(ForumsController) ? :id : :forum_id
    @forum = Forum.find_by_stripped_title(params[key]) or raise ActiveRecord::RecordNotFound
    @page_title = @forum
  end

  def load_topic
    key = is_a?(TopicsController) ? :id : :topic_id
    load_forum
    @topic = @forum.topics.find(params[key])
    @page_title = @topic
  end

  def load_current_user
    @user = User.find(current_user.id)
  end

  # Required rights
  def http_auth_required!
    if request.ssl? and !logged_in?
      request_http_basic_authentication if [Mime::XML, Mime::ATOM, Mime::RSS].include?(request.format)
    end
  end

  def user_required!
    forbidden unless logged_in?
  end

  alias :login_required :user_required!

  def active_required!
    forbidden unless logged_in? && current_user.active?
  end

  def admin_required!
    forbidden unless logged_in? && current_user.can_admin?
  end

  def moderate_required!
    forbidden unless logged_in? && @forum.can_moderate?(current_user)
  end

  def read_required!
    forbidden unless @forum.can_read?(current_user)
  end
  
  def post_required!
    forbidden unless logged_in? && @forum.can_post?(current_user)
  end

  def reply_required!
    forbidden unless logged_in? && @topic.can_reply?(current_user)
  end
  
  def edit_required!
    forbidden unless logged_in? && @post.can_edit?(current_user)
  end

  def topic_edit_required!
    forbidden unless logged_in? && @topic.can_edit?(current_user)
  end

  def delete_required!
    forbidden unless logged_in? && @post.can_delete?(current_user)
  end

  def topic_delete_required!
    forbidden unless logged_in? && @topic.can_delete?(current_user)
  end
end
