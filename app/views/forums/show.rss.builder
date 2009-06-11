xml.instruct! :xml, :version => '1.0'
xml.rss(:version => '2.0') do
  xml.channel do
    xml.title(@forum)
    xml.link(url_for(:format => 'rss',  :only_path => false))
    xml.description(@forum.description)
    xml.language('fr-fr')

    @topics.each do |topic|
      xml.item do
        xml.title(topic)
        xml.category()
        xml.description(format_text(topic.body))
        xml.pubDate(topic.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(forum_topic_url(@forum, topic))
        xml.guid(forum_topic_url(@forum, topic))
      end
    end
  end
end
