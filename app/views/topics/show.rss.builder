xml.instruct! :xml, :version => '1.0'
xml.rss(:version => '2.0') do
  xml.channel do
    xml.title(@topic)
    xml.link(url_for(:format => 'rss',  :only_path => false))
    xml.description()
    xml.language('fr-fr')

    @posts.each do |post|
      xml.item do
        xml.title(@topic)
        xml.category()
        xml.description(format_text(post.body))
        xml.pubDate(post.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(forum_topic_url(@forum, @topic, :page => post.page))
        xml.guid(forum_topic_url(@forum, @topic, :page => post.page))
      end
    end
  end
end
