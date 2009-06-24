class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |table|
      table.with_options :null => false do |t|
        t.belongs_to :forum
        t.belongs_to :topic, :null => true, :default => nil
        t.belongs_to :user
        t.string :ip_address
        t.string :title, :default => ''
        t.text :body
        t.boolean :is_locked, :is_sticky, :default => false
        t.integer :posts_count, :default => 0
      end

      table.datetime :edited_at, :last_post_at
      table.integer :last_reply_id

      table.timestamps
    end

    add_index :posts, :updated_at
    add_index :posts, [:forum_id, :topic_id, :is_sticky, :last_post_at], :name => :index_topics_list


    #execute "ALTER TABLE `posts` " \
    #        "ADD CONSTRAINT `fk_posts_forums` " \
    #        "FOREIGN KEY (`forum_id`) REFERENCES `forums` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"

    #execute "ALTER TABLE `posts` " \
    #        "ADD CONSTRAINT `fk_posts_topics` " \
    #        "FOREIGN KEY (`topic_id`) REFERENCES `posts` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"

    #execute "ALTER TABLE `posts` " \
    #        "ADD CONSTRAINT `fk_posts_users` " \
    #        "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :posts
  end
end
