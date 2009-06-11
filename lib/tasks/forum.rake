namespace :forum do
  desc 'Update last_post_at'
  task(:update_last_post_at => :environment) do
    Topic.find(:all, :conditions => 'topic_id IS NULL').each do |topic|
      topic.update_attribute :last_post_at, topic.last_post.created_at
      puts "Updated #{topic.title}"
    end
  end
end
