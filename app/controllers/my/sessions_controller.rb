class My::SessionsController < ApplicationController
  def show
    redirect_to :action => :new
  end

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if authenticate(params[:login], params[:password])
      flash[:notice] = 'Vous êtes maintenant identifié.'
      redirect_to forums_url
    else
      render :action => :new
    end
  end

  def destroy
    unauthenticate
    flash[:notice] = 'Vous n\'êtes plus identifié.'
    redirect_to forums_url
  end
end
