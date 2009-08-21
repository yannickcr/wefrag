class UserController < ApplicationController

  before_filter :user_required!, :only => [:show, :edit, :update, :destroy]

  before_filter :load_current_user, :only => [:edit, :update, :destroy]
  before_filter :load_pending_user, :only => [:confirm, :cancel]

  before_filter :sanitize_params, :only => [:create, :update]

  def show
    redirect_to :action => :edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new do |u|
      u.login = params[:user][:login]
      u.email = params[:user][:email]
    end

    @user.save!
    @user.register!

    flash[:notice] = 'Vous allez recevoir un mail pour confirmer votre inscription.'
    redirect_to forums_url
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    render :action => :new
  end

  def edit
  end

  def update
    begin
      @user.attributes_from_input = params[:user]

      User.transaction do
        if @user.confirmed? and !params[:image][:uploaded_data].to_s.blank?
          @user.valid? || raise(ActiveRecord::RecordInvalid)
          @image = Image.new(params[:image]) 
          @image.save!
          @user.image.destroy if @user.image
          @user.image = @image
          @user.save(false)
        else
          @user_info.update_attributes!(params[:user_info]) if @user.active?
          @user.save!
        end
      end

      flash[:notice] = 'Votre profil a été mis à jour.'
      redirect_to :action => :edit
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      render :action => :edit
    end
  end

  def destroy
    @user.destroy
    unauthenticate

    flash[:notice] = 'Votre compte a été supprimé.'
    redirect_to forums_url
  end

  def confirm
    @user.notify!
    @user.confirm!
    flash[:notice] = 'Votre adresse e-mail a été confirmée, vous êtes maintenant identifié. Votre compte est actif.'
    self.current_user = @user 
    redirect_to :action => :edit
  end

  def cancel
    @user.cancel!
    flash[:notice] = 'Votre demande d\'inscription a été annulée.'
    redirect_to forums_url
  end

  protected

  def load_current_user
    super
    @user_info = @user.info || @user.build_info
  end

  def sanitize_params
    self.params[:user]      = {} unless params[:user].is_a?(Hash)
    self.params[:user_info] = {} unless params[:user_info].is_a?(Hash)
    self.params[:image]     = {} unless params[:image].is_a?(Hash)
  end

  def user_confirmed_required!
    forbidden unless @user.confirmed?
  end

  def load_pending_user
    @user = User.pending.find_by_confirmation_code(params[:code])
    unless @user
      redirect_to logged_in? ? user_url : forums_url
      return false
    end
  end
end
