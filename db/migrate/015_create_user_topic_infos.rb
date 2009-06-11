class CreateUserTopicInfos < ActiveRecord::Migration
  def self.up
    create_table :user_topic_infos do |t|
      t.integer :user_id,  :null => false
      t.integer :topic_id, :null => false
      t.boolean :is_reply, :null => false, :default => true
      t.timestamps
    end

    add_index :user_topic_infos, [:user_id, :topic_id], :unique => true

    execute "ALTER TABLE `user_topic_infos` " \
            "ADD CONSTRAINT `fk_user_topic_infos_users` " \
            "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"

    execute "ALTER TABLE `user_topic_infos` " \
            "ADD CONSTRAINT `fk_user_topic_infos_topics` " \
            "FOREIGN KEY (`topic_id`) REFERENCES `posts` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :user_topic_infos
  end
end
