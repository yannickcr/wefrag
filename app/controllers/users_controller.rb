class UsersController < ApplicationController

  before_filter :load_user, :only => :show

  def show
    respond_to do |format|
      format.html {
        response.headers['X-XRDS-Location'] = url_for(:format => 'xrds')
      }
      format.xrds {
        response.content_type = 'application/xrds+xml'
        response.charset = false
      }
    end
  end

  def addresses
    @users = Rails.cache.fetch "Users:addresses", :expires_in => 1.hour do
      User.active.address
    end
    respond_to do |format|
      format.xml
    end
  end

  private

  def load_user
    if params[:id].match /^[1-9]\d*$/
      @user = User.find(params[:id])
      redirect_to show_user_url(@user)
    else
      @user = User.find_by_param(params[:id]) or raise ActiveRecord::RecordNotFound
    end
  end
end
