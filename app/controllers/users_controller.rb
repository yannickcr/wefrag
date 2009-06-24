class UsersController < ApplicationController

  before_filter :load_user, :only => :show

  def show
    return
    respond_to do |format|
      format.html {
        response.headers['X-XRDS-Location'] = url_for(:format => 'xrds')
      }
      format.xrds {
        response.content_type = 'application/xrds+xml'
      }
    end
  end

  private

  def load_user
    if params[:id] =~ /^[1-9]\d*$/
      @user = User.find(params[:id])
      redirect_to show_user_url(@user)
    else
      @user = User.find_by_param(params[:id]) or raise ActiveRecord::RecordNotFound
    end
  end
end
