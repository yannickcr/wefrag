class AddLastPostAtIndex < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE `posts` DROP INDEX `fk_posts_forums`, ' +
            'ADD INDEX fk_posts_forums ' +
            'USING BTREE(`forum_id`, `topic_id`, `is_sticky`, `last_post_at`)'
  end

  def self.down
    execute 'ALTER TABLE `posts` DROP INDEX `fk_posts_forums`, ' +
            'ADD INDEX fk_posts_forums USING BTREE(`forum_id`)'
  end
end
