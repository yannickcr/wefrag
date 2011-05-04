class User::PasswordResetMailer < ActionMailer::Base
  default_url_options[:host] = 'forum.nofrag.com'

  def create(pr)
    setup pr
    subject 'Votre demande de nouveau mot de passe sur Wefrag'
  end

  def change(pr)
    setup pr
    subject 'Votre nouveau mot de passe sur Wefrag'
  end

  protected

  def setup(pr)
    recipients pr.user.email
    headers 'Return-Path' => 'ced@wefrag.com'
    from 'ced@wefrag.com'
    body :password_reset => pr
  end
end
