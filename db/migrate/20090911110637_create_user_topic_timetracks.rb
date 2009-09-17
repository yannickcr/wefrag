class CreateUserTopicTimetracks < ActiveRecord::Migration
  def self.up
    create_table :user_topic_timetracks do |table|
      table.with_options :null => false do |t|
        t.belongs_to :user
        t.belongs_to :topic
        t.datetime :tracked_at
        t.integer  :spent, :default => 0
      end
    end

    add_index :user_topic_timetracks, [:user_id, :topic_id, :tracked_at], :unique => true, :name => 'user_and_topic_and_tracked_at'
  end

  def self.down
    drop_table :user_topic_timetracks
  end
end
