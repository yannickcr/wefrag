class CreateShouts < ActiveRecord::Migration
  def self.up
    create_table :shouts do |t|
      t.integer :user_id, :null => false
      t.string  :ip_address, :body
      t.timestamps
    end

    add_index :shouts, :created_at

    execute "ALTER TABLE `shouts` " \
            "ADD CONSTRAINT `fk_shouts_users` " \
            "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
            "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :shouts
  end
end
