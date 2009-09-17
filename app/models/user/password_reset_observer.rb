class User::PasswordResetObserver < ActiveRecord::Observer
  def after_create(pr)
    User::PasswordResetMailer.deliver_create(pr)
    pr.send!
  end

  def after_update(pr)
    return unless pr.state_changed?

    case pr.state
    when :confirmed
      pr.change!
    when :changed
      User::PasswordResetMailer.deliver_change(pr)
      pr.destroy
    end
  end
end

