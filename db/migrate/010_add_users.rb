class AddUsers < ActiveRecord::Migration
  def self.up
    user = User.create! do |u|
      u.login = "test"
      u.email = "test@somerandomwebsite0000.com"
      u.group_id = 1
      u.is_admin = true
    end

    user = User.find(user.id)
    user.crypted_password = user.encrypt('test')
    user.state = 'active'
    user.save!
  end

  def self.down
  end
end
