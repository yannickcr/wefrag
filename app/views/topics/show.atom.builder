atom_feed :url => forum_topic_url(@forum, @topic) do |feed|
  feed.title(@topic)
  feed.updated(@posts.first ? @posts.first.created_at : Time.now.utc)

  @posts.each do |post|
    feed.entry post, :url => forum_topic_url(@forum, @topic, :page => post.page) do |entry|
      entry.title(@topic)
      entry.content(format_text(post.body), :type => 'html')
      entry.author do |author|
        author.name(post.user)
      end
    end
  end
end
