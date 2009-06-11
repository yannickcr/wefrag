class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :login, :email, :null => false
      t.integer  :group_id
      t.boolean  :is_admin, :default => false, :null => false
      t.string   :crypted_password, :salt, :limit => 40
      t.string   :confirmation_code, :limit => 40
      t.string   :first_name, :last_name, :city, :country, :default => ''
      t.date     :birthdate
      t.enum     :state, :limit => [:passive, :pending, :notified, :confirmed, :accepted, :refused, :active, :disabled], :default => :passive, :null => false
      t.timestamps
    end
    
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :confirmation_code

    execute "ALTER TABLE `users` " \
            "ADD CONSTRAINT `fk_users_groups` " \
            "FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) " \
            "ON DELETE SET NULL ON UPDATE CASCADE"
  end

  def self.down
    drop_table "users"
  end
end
