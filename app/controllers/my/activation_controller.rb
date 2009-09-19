class My::ActivationController < ApplicationController
  before_filter :load_user

  def show
    @user.notify!
    @user.confirm!

    self.current_user = @user

    flash[:notice] = 'Votre adresse e-mail a été confirmée, vous êtes maintenant identifié. Votre compte est actif.'
    redirect_to edit_user_url
  end

  protected

  def load_user
    unless @user = User.pending.find_by_confirmation_code(params[:id])
      redirect_to logged_in? ? user_url : forums_url
      return false
    end
  end
end
