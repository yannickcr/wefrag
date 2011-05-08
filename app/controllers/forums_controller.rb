class ForumsController < ApplicationController
  before_filter :load_forum,       :except => [:home, :index, :unread, :read_all]
  before_filter :read_required!,   :except => [:home, :index, :unread, :read_all]
  before_filter :active_required!, :only   => [:unread, :read_all]
  before_filter :has_feed,         :only   => :show

  before_filter :sanitize_params, :only => :show

  def home
    headers['X-XRDS-Location'] = openid_info_url
    redirect_to :action => :index
  end

  def index
    headers['X-XRDS-Location'] = openid_info_url
    @categories = Category.all_with_forums
  end

  def show
    @topics = @forum.topics.paginate(:page => params[:page], :total_entries => @forum.topics_count)
    raise WillPaginate::InvalidPage.new(params[:page], params[:page]) if @topics.out_of_bounds? && @topics.current_page > 1
  end

  def unread
    forums    = current_user.readable_forums
    forum_ids = forums ? forums.collect { |r| r.id } : []

    if forum_ids.empty?
      @topics = []
    else
      @topics = Topic.paginate(:page => params[:page], :per_page => Topic.per_page,
                               :joins => "LEFT OUTER JOIN `user_topic_reads` ON `user_topic_reads`.topic_id = `posts`.id AND `user_topic_reads`.user_id = #{current_user.id}",
                               :conditions => ["`posts`.forum_id IN (#{forum_ids.join(',')}) " +
                                               "AND `posts`.topic_id IS NULL " +
                                               "AND `posts`.created_at > ? " +
                                               "AND (`user_topic_reads`.user_id IS NULL OR " +
                                               "(`user_topic_reads`.is_forever = 0 AND `user_topic_reads`.read_at < `posts`.last_post_at))", current_user.created_at],
                               :include => :user)
      raise WillPaginate::InvalidPage.new(params[:page], params[:page]) if @topics.out_of_bounds? && @topics.current_page > 1
    end
  end

  def read
    UserTopicRead.read_forum!(current_user, @forum) if logged_in?
    redirect_to forums_url
  end

  def read_all
    UserTopicRead.read_forums!(current_user) if logged_in?
    redirect_to forums_url
  end

  protected

  def sanitize_params
    params[:page] = params[:page] ? params[:page].to_i : 1
  end
end
