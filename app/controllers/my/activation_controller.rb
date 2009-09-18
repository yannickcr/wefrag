class My::ActivationController < ApplicationController
  before_filter :load_pending_user

  def show
    @user.notify!
    @user.confirm!

    flash[:notice] = 'Votre adresse e-mail a été confirmée, vous êtes maintenant identifié. Votre compte est actif.'
    redirect_to :action => :edit
  end

  def cancel
  end

  def destroy
    @user.cancel!
    flash[:notice] = 'Votre demande d\'inscription a été annulée.'
    redirect_to forums_url
  end

  protected

  def load_pending_user
    unless @user = User.pending.find_by_confirmation_code(params[:code])
      redirect_to logged_in? ? user_url : forums_url
      return false
    end
  end
end
