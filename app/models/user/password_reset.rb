class User::PasswordReset < ActiveRecord::Base
  belongs_to :user
  before_create :make_code

  def send!
    update_attribute :state, :sent
  end
    
  def confirm!
    update_attribute :state, :confirmed
  end

  def change!
    user.make_new_password!
    update_attribute :state, :changed
  end

  protected

  def make_code
    self.code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
