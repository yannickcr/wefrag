class AddGroups < ActiveRecord::Migration
  def self.up
    Group.create! :title => "Admin"
  end

  def self.down
  end
end
