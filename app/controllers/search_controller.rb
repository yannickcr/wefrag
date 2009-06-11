 class SearchController < ApplicationController
  before_filter :sanitize_params

  def new
    @string = ''
  end

  def create
    @string = URI.escape(params[:s])

    unless @string.empty?
      redirect_to search_url(@string)
    else
      render :action => :new
    end
  end

  def show
    @string = URI.unescape(params[:s])
    forums    = logged_in? ? current_user.readable_forums : Group.anonymous.readable_forums
    forum_ids = forums ? forums.collect { |f| f.id } : []

    unless forum_ids.empty? or @string.empty? or params[:s].size < 3
      Ultrasphinx::Search.excerpting_options[:before_match] = '[b]'
      Ultrasphinx::Search.excerpting_options[:after_match]  = '[/b]'
      Ultrasphinx::Search.excerpting_options[:limit]        = 512
      Ultrasphinx::Search.excerpting_options[:around]       = 3
      Ultrasphinx::Search.excerpting_options[:content_methods] = ['body']

      @search = Ultrasphinx::Search.new(
        :query     => '@@relaxed ' + @string,
        :page      => params[:page],
        :sort_mode => 'descending',
        :sort_by   => 'created_at',
        :filters   => { 'forum_id' => forum_ids }
      )

      @search.excerpt
      render_404 if params[:page] > [1, @search.page_count].max
    else
      @search = nil
    end
  end

  private

  def sanitize_params
    self.params[:s]    = params[:s].to_s
    self.params[:page] = params[:page].to_s.to_i
  end
end
