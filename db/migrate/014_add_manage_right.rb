class AddManageRight < ActiveRecord::Migration
  def self.up
    add_column :group_forum_rights, :is_topic_moderate, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :group_forum_rights, :is_topic_moderate
  end
end
