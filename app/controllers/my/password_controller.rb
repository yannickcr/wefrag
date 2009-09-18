class My::PasswordController < ApplicationController
  before_filter :load_password_reset, :only => :show

  def index
    redirect_to :action => :new
  end

  def show
    @user = @password_reset.user
    @password_reset.confirm!

    flash[:notice] = 'Un nouveau mot de passe a été généré et vous a été envoyé à votre adresse e-mail'
    redirect_to forums_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.authenticatable.find_by_login_or_email(params[:login_or_email]) 

    if @user
      @password_reset = @user.request_new_password!

      flash[:notice] = 'Vous allez recevoir un mail pour confirmer votre demande de nouveau mot de passe.'
      redirect_to forums_url
    else
      render :action => :new
    end
  end

  protected

  def load_password_reset
    @password_reset = User::PasswordReset.find_by_code(params[:id]) or raise ActiveRecord::RecordNotFound
  end
end
