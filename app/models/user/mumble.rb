require 'digest/sha1'
class User::Mumble < ActiveRecord::Base
  belongs_to :user
  before_create :set_random_password

  def to_s
    "#{url}"
  end

  def url
    "mumble://#{user}@wefrag.com"
  end

  def url_with_password
    "mumble://#{user}:#{password}@wefrag.com"
  end

  def password_sha1
    Digest::SHA1.hexdigest("#{password}")
  end

  protected

  def set_random_password
    self.password = Password.generate(8, Password::ONE_DIGIT)
  end
end
