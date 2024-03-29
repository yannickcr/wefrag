class TopicsController < ApplicationController
  before_filter :load_forum, :only   => [:new, :create]
  before_filter :load_topic, :except => [:new, :create, :timetrack, :unread]
  before_filter :load_user,  :only   => :ban

  before_filter :load_topic_only, :only => :timetrack

  before_filter :read_required!,         :except => :unread
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

  skip_before_filter :verify_authenticity_token, :only => :timetrack

  def show
    respond_to do |format|
      format.html do
        @posts = @topic.posts.oldest.paginate(:page => params[:page], :per_page => Post.per_page, :total_entries => @topic.posts_count)
        raise WillPaginate::InvalidPage.new(params[:page], params[:page].to_i) if @posts.out_of_bounds? && @posts.current_page > 1
      end
      format.rss do
        @posts = @topic.posts.oldest.all(:order => '`posts`.created_at DESC', :limit => 25)
      end
      format.atom do
        @posts = @topic.posts.oldest.all(:order => '`posts`.created_at DESC', :limit => 25)
      end
    end
  end
  
  def unread
    @unread_posts = Post.paginate(:page => params[:page], :per_page => Post.per_page, 
                                  :select => 'posts.*',
                                  :from => 'posts, users, group_forum_rights ',
                                  :order => 'posts.updated_at DESC',
                                  :conditions => "users.id =#{current_user.id} AND users.group_id = group_forum_rights.group_id AND group_forum_rights.is_read = 1 AND group_forum_rights.forum_id = posts.forum_id AND ((title != '' AND posts.id NOT IN (SELECT user_topic_reads.topic_id FROM user_topic_reads WHERE user_topic_reads.user_id = #{current_user.id} AND (user_topic_reads.read_at >= posts.created_at OR user_topic_reads.is_forever = 1))) OR (title = '' AND posts.topic_id NOT IN (SELECT user_topic_reads.topic_id FROM user_topic_reads WHERE user_topic_reads.user_id =#{current_user.id} AND (user_topic_reads.read_at >= posts.created_at OR user_topic_reads.is_forever = 1))))")
    raise WillPaginate::InvalidPage.new(params[:page], params[:page].to_i) if @unread_posts.out_of_bounds? && @unread_posts.current_page > 1
    render :template => 'topics/posts'
  end

  def new
    @topic = @forum.topics.new do |t|
      t.user = current_user
    end
  end

  def quote
    @post = @topic.replies.new(:body => "[quote][u][b]#{@topic.user}[/b] a dit :[/u]\n" + @topic.body + "[/quote]\n")
    render :template => 'posts/new'
  end

  def create
    begin
      @topic = @forum.topics.new(params[:topic]) do |t|
        t.user = current_user
        t.ip_address = request.remote_ip
      end

      @topic.save!

      flash[:notice] = 'Le sujet a été créé.'
      flash[:notice] += ' (<a href="http://play.wefrag.com">Planifier cet événement sur weplay ?</a>' if @forum.is_weplay?
      redirect_to :action => :show, :id => @topic
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
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

  def timetrack
    UserTopicTimetrack.track!(current_user, @topic, params[:time]) if logged_in?
    render :nothing => true
  end

  protected

  def load_topic_only
    @topic = Topic.find(params[:id])
    @forum = @topic.forum
  end

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
