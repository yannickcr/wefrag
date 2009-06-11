class ForumsController < ApplicationController

  before_filter :load_forum,       :except => [:home, :index, :read_all]
  before_filter :read_required!,   :except => [:home, :index, :read_all]
  before_filter :active_required!, :only   => :read_all
  before_filter :has_feed,         :only   => :show

  before_filter :sanitize_params, :only => :show

  def home
    response.headers['X-XRDS-Location'] = openid_info_url
    redirect_to :action => :index
  end

  def index
    response.headers['X-XRDS-Location'] = openid_info_url
    @categories = Category.all_with_forums
  end

  def show
    @topics = @forum.topics.latests.paginate(:page => params[:page], :total_entries => @forum.topics_count)
    raise WillPaginate::InvalidPage.new(params[:page], params[:page]) if @topics.out_of_bounds? && @topics.current_page > 1

    respond_to do |format|
      format.html
      format.rss
      format.atom
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
