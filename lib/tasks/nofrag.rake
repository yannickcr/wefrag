namespace :nofrag do
  desc 'Import Nofrag news'
  task(:import => :environment) do
    require 'rss'
    rss = RSS::Parser.parse('http://www.nofrag.com/fb/nofrag.rss', true)

    rss.items.each do |item|
      remote_id   = /\/([0-9]+)\/$/.match(item.guid.content)[1].to_s.to_i

      begin
        ImportedNofragItem.create! do |n|
          n.remote_id    = remote_id
          n.title        = item.title
          n.url          = item.guid.content
          n.description  = item.description
          n.published_at = DateTime.parse(item.pubDate.to_s)
        end
        puts "Added #{remote_id}"
      rescue ActiveRecord::StatementInvalid
        puts "Ignored #{remote_id}"
      end
    end
  end

  desc 'Create topics from Nofrag news'
  task(:create_topics => :environment) do
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::SanitizeHelper::ClassMethods

    forum = Forum.find_by_stripped_title('nofrag') or raise ActiveRecord::RecordNotFound
    user  = User.find_by_login('nofrag') or raise ActiveRecord::RecordNotFound

    ImportedNofragItem.unposted.all(:order => 'published_at ASC').each do |item|

      description = strip_tags(item.description.gsub(/<br\s*\/?\s*>/, "\n").gsub(/\n\n+/, "\n\n")).strip
      description.sub!("\n\nLire la suite sur Nofrag...", '')
      description += "\n\n[url=#{item.url}]Lire toute la news sur Nofrag.com...[/url]"

      Topic.transaction do
        topic = forum.topics.create! do |t|
          t.user_id = user.id
          t.title   = truncate(strip_tags(item.title).strip, :length => 90)
          t.body    = description
        end
        item.update_attributes!(:topic_id => topic.id)
        puts "Created topic for \"#{topic.title}\""
      end
    end
    puts "Topics created."
  end

  desc 'Delete topics from Nofrag news'
  task(:delete_topics => :environment) do
    ImportedNofragItem.posted.each do |item|
      Topic.transaction do
        item.topic.destroy if item.topic
        item.destroy
      end
    end
  end
end
