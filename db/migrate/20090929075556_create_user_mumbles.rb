class CreateUserMumbles < ActiveRecord::Migration
  def self.up
    create_table :user_mumbles do |table|
      table.with_options :null => false do |t|
        t.belongs_to :user
        t.string     :password,  :limit => 40
      end
    end

    add_index :user_mumbles, :user_id, :unique => true
  end

  def self.down
    drop_table :user_mumbles
  end
end
