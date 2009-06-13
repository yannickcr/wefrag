# Use this migration to create the tables for the ActiveRecord store
class CreateUserOpenidTrusts < ActiveRecord::Migration
  def self.up
    create_table :user_openid_trusts do |t|
      t.integer :user_id, :null => false
      t.string  :trust_root
      t.timestamps
    end

    add_index :user_openid_trusts, [:user_id, :trust_root]

    #execute "ALTER TABLE `user_openid_trusts` " \
    #        "ADD CONSTRAINT `fk_user_openid_trusts_users` " \
    #        "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :user_openid_trusts
  end
end
