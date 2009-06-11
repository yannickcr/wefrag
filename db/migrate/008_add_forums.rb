class AddForums < ActiveRecord::Migration
  def self.up
    category = Category.create! :title => "Vrac"

    forum = category.forums.create!(:title => "Bienvenue", :stripped_title => "bienvenue")
    forum = category.forums.create!(:title => "Blabla", :stripped_title => "blabla")
    forum = category.forums.create!(:title => "Admin", :stripped_title => "admin")
  end

  def self.down
  end
end
