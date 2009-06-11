class CreateUserTopicReads < ActiveRecord::Migration
  def self.up
    create_table :user_topic_reads do |t|
      t.integer :user_id, :null => false
      t.integer :topic_id, :null => false
      t.datetime :read_at
    end

    add_index :user_topic_reads, [:user_id, :topic_id], :unique => true

    execute "ALTER TABLE `user_topic_reads` " \
            "ADD CONSTRAINT `fk_user_topic_reads_users` " \
            "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"

    execute "ALTER TABLE `user_topic_reads` " \
            "ADD CONSTRAINT `fk_user_topic_reads_topics` " \
            "FOREIGN KEY (`topic_id`) REFERENCES `posts` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :user_topic_reads
  end
end
