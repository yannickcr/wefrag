class UserMailer < ActionMailer::Base
  default_url_options[:host] = 'www.wefrag.com'

  def register(user)
    setup user
    subject 'Validez votre inscription sur Wefrag'
  end

  def unconfirmed(user)
    setup user
    subject 'Votre demande d\'inscription sur wefrag a été annulée'
  end

  def accept(user)
    setup user
    subject 'Votre demande d\'inscription sur wefrag a été acceptée'
  end

  def refuse(user)
    setup user
    subject 'Votre demande d\'inscription sur wefrag a été rejetée'
  end

  def uncomplete(user)
    setup user
    subject 'Votre demande d\'inscription sur wefrag a été rejetée'
  end

  def underage(user)
    setup user
    subject 'Votre demande d\'inscription sur wefrag a été rejetée'
  end

  private

  def setup(user)
    recipients user.email
    headers 'Return-Path' => 'ced@wefrag.com'
    from 'ced@wefrag.com'
    body :user => user
  end
end
