class AddUsers < ActiveRecord::Migration
  def self.up
    user = User.new do |u|
      u.login = "ced"
      u.email = "ced@wal.fr"
      u.password = "test"
      u.password_confirmation = "test"
      u.group_id = 1
      u.is_admin = true
      u.state = 'active'
    end
    user.register!
  end

  def self.down
  end
end
