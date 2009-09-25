 class SearchController < ApplicationController
  def new
    @string = ""
  end

  def create
    @string = URI.escape("#{params[:s]}")

    unless @string.empty?
      redirect_to search_url(@string)
    else
      render :action => :new
    end
  end

  def show
    @string = URI.unescape("#{params[:s]}")

    forums    = logged_in? ? current_user.readable_forums : Group.anonymous.readable_forums
    forum_ids = forums ? forums.collect { |f| f.id } : []

    unless !defined?(Ultrasphinx) or forum_ids.empty? or @string.empty? or @string.size < 3
      @search = Ultrasphinx::Search.new(
        :query     => "@@relaxed #{@string}",
        :page      => "#{params[:page]}".to_i,
        :filters   => { 'forum_id' => forum_ids }
      )

      @search.excerpt
      render_404 if @search.current_page > [1, @search.page_count].max
    else
      @search = nil
    end
  rescue Ultrasphinx::DaemonError
    @search = nil
  end
end
