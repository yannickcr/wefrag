class CreateUserInfos < ActiveRecord::Migration
  def self.up
    create_table :user_infos do |t|
      t.integer  :user_id, :null => false
      t.string   :steam_id, :xboxlive_id, :psn_id
      t.string   :job, :website
      t.boolean  :is_email, :default => true
      t.timestamps
    end

    add_index :user_infos, :user_id, :unique => true

    #execute "ALTER TABLE `user_infos` " \
    #        "ADD CONSTRAINT `fk_user_info_users` " \
    #        "FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) " \
    #        "ON DELETE CASCADE ON UPDATE CASCADE"
  end

  def self.down
    drop_table :user_infos
  end
end
