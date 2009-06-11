class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer  :forum_id, :null => false
      t.integer  :topic_id
      t.integer  :user_id, :null => false
      t.string   :title, :ip_address
      t.text     :body
      t.boolean  :is_locked, :is_sticky, :default => false
      t.datetime :edited_at
      t.timestamps
      #
      t.integer  :posts_count, :default => 0
    end

    add_index :posts, :updated_at

    execute "ALTER TABLE `posts` " \
            "ADD CONSTRAINT `fk_posts_forums` " \
            "FOREIGN KEY (`forum_id`) REFERENCES `forums` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"

    execute "ALTER TABLE `posts` " \
            "ADD CONSTRAINT `fk_posts_topics` " \
            "FOREIGN KEY (`topic_id`) REFERENCES `posts` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"

    execute "ALTER TABLE `posts` " \
            "ADD CONSTRAINT `fk_posts_users` " \
            "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :posts
  end
end
