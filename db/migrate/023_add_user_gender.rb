class AddUserGender < ActiveRecord::Migration
  def self.up
    add_column :users, :gender, :enum, :limit => [:male, :female], :default => :male
  end

  def self.down
    remove_column :users, :gender
  end
end

