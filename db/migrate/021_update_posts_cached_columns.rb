class UpdatePostsCachedColumns < ActiveRecord::Migration
  def self.up
    Topic.find(:all, :conditions => '`posts`.topic_id IS NULL').each do |topic|
      topic.update_cached_columns
    end
  end

  def self.down
  end
end

