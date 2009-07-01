class ShoutsController < ApplicationController

  before_filter :load_shout, :except => [:index, :box, :new, :create]
  before_filter :active_required!
  before_filter :admin_required!, :only => :destroy

  before_filter :sanitize_params, :only => :create

  skip_before_filter :verify_authenticity_token, :only => :index

  def index
    @shouts = Shout.paginate(:page => params[:page])

    respond_to do |format|
      format.html
      format.js
      format.json do
        render :json => @shouts.to_json
      end
    end
  end

  def box
    render :layout => 'simple'
  end

  def new
    @shout = Shout.new
  end

  def create
    @shout = Shout.new(params[:shout]) do |s|
      s.user = current_user
      s.ip_address = request.remote_ip
    end

    @shout.save!

    flash[:notice] = 'Le message a été ajouté.'
    redirect_to forums_url
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    render :action => :new
  end

  def destroy
    @shout.destroy
    flash[:notice] = 'Le message a été supprimé.'
    redirect_to forums_url
  end

  private

  def load_shout
    @shout = Shout.find(params[:id])
  end

  def sanitize_params
    params[:shout] = {} unless params[:shout].is_a?(Hash)
  end
end
