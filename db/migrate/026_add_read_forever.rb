class AddReadForever < ActiveRecord::Migration
  def self.up
    add_column :user_topic_reads, :is_forever, :boolean, :default => false
  end

  def self.down
    remove_column :user_topic_reads, :is_forever
  end
end

