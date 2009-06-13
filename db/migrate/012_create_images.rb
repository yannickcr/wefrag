class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :parent_id
      t.string :content_type, :filename, :thumbnail
      t.integer :size, :height, :width
      t.timestamps
    end

    add_column :users, :image_id, :integer

    #execute "ALTER TABLE `users` " \
    #        "ADD CONSTRAINT `fk_users_images` " \
    #        "FOREIGN KEY (`image_id`) REFERENCES `images` (`id`) " \
    #        "ON DELETE SET NULL ON UPDATE CASCADE"
  end

  def self.down
    remove_column :users, :image_id
    drop_table :images
  end
end
