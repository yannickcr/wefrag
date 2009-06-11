class CreateGroupForumRights < ActiveRecord::Migration
  def self.up
    create_table :group_forum_rights do |t|
      t.integer :group_id, :null => false
      t.integer :forum_id, :null => false
      t.boolean  :is_read, :is_post, :is_reply, :is_edit, :null => false, :default => true
      t.boolean  :is_moderate, :null => false, :default => false
      t.timestamps
    end

    add_index :group_forum_rights, [:group_id, :forum_id], :unique => true

    execute "ALTER TABLE `group_forum_rights` " \
            "ADD CONSTRAINT `fk_group_forum_rights_groups` " \
            "FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"

    execute "ALTER TABLE `group_forum_rights` " \
            "ADD CONSTRAINT `fk_group_forum_rights_forums` " \
            "FOREIGN KEY (`forum_id`) REFERENCES `forums` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :group_forum_rights
  end
end
