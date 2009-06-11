class AddForumsIndex < ActiveRecord::Migration
  def self.up
    add_index :forums, :stripped_title, :unique => true
  end

  def self.down
    remove_index :forums, :stripped_title
  end
end
