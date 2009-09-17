class CreateUserPasswordResets < ActiveRecord::Migration
  def self.up
    create_table :user_password_resets do |table|
      table.with_options :null => false do |t|
        t.belongs_to :user
        t.string     :code,  :limit => 40
        t.enum       :state, :limit => [:created, :sent, :confirmed, :changed], :default => :created
      end
    end

    add_index :user_password_resets, :code, :unique => true
  end

  def self.down
    drop_table :user_password_resets
  end
end
