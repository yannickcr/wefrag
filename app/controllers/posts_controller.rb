class PostsController < ApplicationController

  before_filter :load_topic, :except => :preview
  before_filter :load_post,  :except => [:preview, :new, :create]

  before_filter :read_required!,   :except => :preview
  before_filter :active_required!, :only   => :preview
  before_filter :reply_required!,  :only   => [:new, :create]
  before_filter :edit_required!,   :only   => [:edit, :update]
  before_filter :delete_required!, :only   => :destroy

  before_filter :sanitize_params, :only => [:create, :update]

  skip_before_filter :verify_authenticity_token, :only => :preview

  def new
    @post = @topic.posts.new do |p|
      p.user = current_user
    end

    @posts = @topic.posts.latest
  end

  def preview
    begin
      data = Iconv.conv('utf-8', 'ISO-8859-1', params[:data].to_s)
    rescue Iconv::IllegalSequence, Iconv::InvalidEncoding
      data = ''
    end
    @post = Post.new(:body => data)
    render :layout => 'simple'
  end

  def quote
    @post = @topic.posts.new do |p|
      p.body = "[quote][u][b]#{@post.user}[/b] a dit :[/u]\n#{@post.body}[/quote]\n"
      p.user = current_user
    end

    @posts = @topic.posts.latest
    render :action => :new
  end

  def create
    begin
      @post = @topic.posts.new(params[:post]) do |p|
        p.user = current_user
        p.ip_address = request.remote_ip
      end

      @post.save!

      flash[:notice] = 'La réponse a été ajoutée.'
      redirect_to forum_topic_url(@topic.forum, @topic, :page => @topic.reload.last_page)
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      @posts = @topic.posts.latest
      render :action => :new
    end
  end

  def edit
  end

  def update
    begin
      @post.update_attributes!(params[:post])
      flash[:notice] = 'La réponse a été mise à jour.'
      redirect_to forum_topic_url(@forum, @topic, :page => @post.page)
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      @posts = @topic.posts(:order => '`posts`.created_at DESC', :limit => 25)
      render :action => :edit
    end
  end

  def destroy
    page = @post.page
    @post.destroy
    flash[:notice] = 'La réponse à été supprimée.'
    redirect_to forum_topic_url(@forum, @topic, :page => [page, @topic.reload.last_page].min)
  end

  private

  def load_post
    @post  = @topic.posts.find(params[:id])
  end

  def sanitize_params
    params[:post] = {} unless params[:post].is_a?(Hash)
  end
end
