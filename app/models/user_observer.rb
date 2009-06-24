class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_register(user)
  end

  def after_save(user)
    if user.accepted? 
      UserMailer.deliver_accept(user)
    end
    user.delete_cache
  end

  def after_destroy(user)
    if user.pending? || user.notified?
      UserMailer.deliver_unconfirmed(user)
    elsif user.confirmed? && !user.is_complete?
      UserMailer.deliver_uncomplete(user)
    elsif user.is_underage? and user.confirmed? || user.refused?
      UserMailer.deliver_underage(user)
    elsif user.refused?
      UserMailer.deliver_refuse(user)
    end
    user.delete_cache
  end
end

