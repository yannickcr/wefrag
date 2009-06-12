class AddGroups < ActiveRecord::Migration
  def self.up
    Group.create! :title => "Admin"
    Group.create! :title => "Member"
    Group.create! :title => "Anonymous"
  end

  def self.down
  end
end
