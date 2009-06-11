class AddLastPostAt < ActiveRecord::Migration
  def self.up
    add_column :posts, :last_post_at, :datetime
  end

  def self.down
    remove_column :posts, :last_post_at
  end
end

