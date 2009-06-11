atom_feed :url => @forum do |feed|
  feed.title(@forum)
  feed.subtitle(@forum.description)
  feed.updated(@topics.first ? @topics.first.created_at : Time.now.utc)

  @topics.each do |topic|
    feed.entry topic, :url => forum_topic_url(@forum, topic) do |entry|
      entry.title(topic)
      entry.content(format_text(topic.body), :type => 'html')
      entry.author do |author|
        author.name(topic.user)
      end
    end
  end
end
