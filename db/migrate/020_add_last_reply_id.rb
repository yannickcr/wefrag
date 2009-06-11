class AddLastReplyId < ActiveRecord::Migration
  def self.up
    add_column :posts, :last_reply_id, :integer
  end

  def self.down
    remove_column :posts, :last_reply_id
  end
end

