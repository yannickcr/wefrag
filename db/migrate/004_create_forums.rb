class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |table|
      table.with_options :null => false do |t|
        t.belongs_to :category
        t.integer :position, :default => 1
        t.string :title, :stripped_title
        t.text :description, :default => ''
      end

      table.timestamps
    end

    add_index :forums, :stripped_title, :unique => true

    #execute "ALTER TABLE `forums` " \
    #        "ADD CONSTRAINT `fk_forums_categories` " \
    #        "FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :forums
  end
end
