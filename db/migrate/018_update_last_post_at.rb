class UpdateLastPostAt < ActiveRecord::Migration
  def self.up
    Topic.find(:all, :conditions => '`posts`.topic_id IS NULL').each do |topic|
      topic.update_last_post_at
    end
  end

  def self.down
  end
end

