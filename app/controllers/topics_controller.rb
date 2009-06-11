class TopicsController < ApplicationController

  before_filter :load_forum, :only   => [:new, :create]
  before_filter :load_topic, :except => [:new, :create]
  before_filter :load_user,  :only   => :ban

  before_filter :read_required!
  before_filter :active_required!,       :only => [:read, :read_forever]
  before_filter :post_required!,         :only => [:new, :create]
  before_filter :topic_edit_required!,   :only => [:edit, :update]
  before_filter :topic_delete_required!, :only => :destroy
  before_filter :lock_required!,         :only => :lock
  before_filter :ban_required!,          :only => :ban
  before_filter :moderate_required!,     :only => :stick
  before_filter :admin_required!,        :only => :move

  before_filter :has_feed,               :only => :show
  before_filter :sanitize_params, :only => [:create, :update, :move]

  after_filter :read_topic, :only => :show

  # Cache
  #caches_action :show, { :ttl => 10.minutes, :if => Proc.new { |c| [Mime::ATOM, Mime::RSS].include?(c.request.format) } }

  def show
    respond_to do |format|
      format.html do
        @posts = @topic.paginate_posts(:page => params[:page], :per_page => Post.per_page, :total_entries => @topic.posts_count)
        raise WillPaginate::InvalidPage.new(params[:page], params[:page].to_i) if @posts.out_of_bounds? && @posts.current_page > 1
      end
      format.rss do
        @posts = @topic.posts(:order => '`posts`.created_at DESC', :limit => 25)
      end
      format.atom do
        @posts = @topic.posts(:order => '`posts`.created_at DESC', :limit => 25)
      end
    end
  end

  def new
    @topic = Topic.new
  end

  def quote
    @post = @topic.replies.new(:body => "[quote][u][b]#{@topic.user}[/b] a dit :[/u]\n" + @topic.body + "[/quote]\n")
    render :template => 'posts/new'
  end

  def create
    begin
      @topic = @forum.topics.create!(params[:topic]) do |t|
        t.user = current_user
        t.ip_address = request.remote_ip
      end

      flash[:notice] = 'Le sujet a été créé.'
      flash[:notice] += ' (<a href="http://play.wefrag.com">Planifier cet événement sur weplay ?</a>' if @forum.is_weplay?
      redirect_to :action => :show, :id => @topic
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid => e
      @topic = e.record
      render :action => :new
    end
  end

  def edit
  end

  def update
    begin
      @topic.update_attributes!(params[:topic])
      flash[:notice] = 'Le sujet a été mis à jour.'
      redirect_to :action => :show
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      render :action => :edit
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = 'Le sujet a été supprimé.'
    redirect_to @forum
  end

  def lock
    @topic.toggle!(:is_locked)
    flash[:notice] = 'Le sujet a été ' + (@topic.is_locked ? 'verrouillé' : 'déverrouillé') + '.'
    redirect_to :action => :show
  end

  def stick
    @topic.toggle!(:is_sticky)
    flash[:notice] = 'Le sujet a été marqué comme ' + (@topic.is_sticky ? 'important' : 'normal') + '.'
    redirect_to :action => :show
  end

  def ban
    ban = @topic.ban!(@user)
    flash[:notice] = 'Le membre ' + (ban.is_reply ? 'n\'est pas exclu' : 'est exclu') + ' du sujet.'
    redirect_to :action => :show
  end

  def move
    if request.post? && @topic.move(params[:topic][:forum_id])
      flash[:notice] = 'Le sujet a été déplacé.'
      redirect_to @topic.forum
    end
  end

  def read
    UserTopicRead.read!(current_user, @topic, @topic.last_post.created_at)
    redirect_to @forum
  end

  def read_forever
    UserTopicRead.read_forever!(current_user, @topic)
    redirect_to @forum
  end

  protected

  def lock_required!
    forbidden unless logged_in? && @topic.can_lock?(current_user)
  end

  def ban_required!
    forbidden unless logged_in? && @topic.can_ban?(current_user)
  end

  def load_user
    @user = User.active.find(params[:user_id])
  end

  def sanitize_params
    params[:topic] = {} unless params[:topic].is_a?(Hash) 
  end

  def read_topic
    unless [Mime::XML, Mime::ATOM, Mime::RSS].include?(request.format)
      if logged_in? && last_post = @posts.last
        UserTopicRead.read!(current_user, @topic, last_post.created_at)
      end
    end
  end
end
