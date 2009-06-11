require 'pathname'

# load the openid library, first trying rubygems
#begin
#  require "rubygems"
#  require_gem "ruby-openid", ">= 1.0"
#rescue LoadError
require "openid"
require "openid/consumer/discovery"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
#end

class OpenidController < ApplicationController
  include OpenID::Server

  skip_before_filter :verify_authenticity_token, :only => :index

  def index
    @req = get_openid_request(params) or return

    if logged_in? && is_authorized?(@req, current_user)
      authorize!(@req, current_user) and return
    else
      redirect_to :action => :decide, :req => encode_params(params)
    end
  end

  def info
    response.headers['content-type'] = 'application/xrds+xml; charset=utf-8'
  end

  def decide
    @req = get_openid_request(decode_params(params[:req])) or return

    if @req.id_select
      if logged_in? and current_user.active?
        @user = current_user
        auth_required = false
      else
        @user = nil
        auth_required = true
      end
    else
      if @user = User.active.find_by_openid(@req.identity)
        if logged_in? && current_user.id == @user.id
          auth_required = false
        else
          auth_required = true
        end
      else
        render :text => 'Invalid OpenID identity.' and return
      end
    end

    if request.post? 
      is_auth = false

      if auth_required
        if !@user
          if @user = User.authenticate(params[:login], params[:password])
            if @user.active?
              is_auth = true
            end
          end
        else
          is_auth = true if @user.authenticated?(params[:password])
        end

        if is_auth && params[:remember_me] == '1'
          self.current_user = @user
        end
      else
        is_auth = true
      end

      if is_auth
        if params[:refuse]
          redirect_to @req.cancel_url and return
        else
          @user.openid_trusts.create(:trust_root => @req.trust_root)
          authorize!(@req, @user) and return
        end
      end
    end

    if auth_required
      render :template => 'openid/auth_and_decide'
    end
  end

  protected

  def server
    @server ||= Server.new(ActiveRecordStore.new, openid_server_url)
  end

  def refuse!
    req.answer(false, openid_server_url)
  end

  def add_sreg(user, req, resp)
    if sreg_req = OpenID::SReg::Request.from_openid_request(req)
      data = {
        'nickname' => user.login
      }
      sreg_resp = OpenID::SReg::Response.extract_response(sreg_req, data)
      resp.add_extension(sreg_resp)
    end
  end

  def add_pape(user, req, resp)
    if OpenID::PAPE::Request.from_openid_request(req)
      pape_resp = OpenID::PAPE::Response.new
      pape_resp.nist_auth_level = 0 # we don't even do auth at all!
      resp.add_extension(pape_resp)
    end
  end

  def render_response(resp)
    #if resp.needs_signing
    #  signed_response = server.signatory.sign(resp)
    #end
    web_response = server.encode_response(resp)

    case web_response.code
    when HTTP_OK
      render :text => web_response.body, :status => 200
    when HTTP_REDIRECT
      redirect_to web_response.headers['location']
    else
      render :text => web_response.body, :status => 400
    end
  end

  def get_openid_request(data)
    begin
      req = server.decode_request(data)
    rescue ProtocolError => e
      # invalid openid request, so just display a page with an error message
      render :text => e.to_s, :status => 500 and return
    end

    # no openid.mode was given
    unless req
      render :text => 'This is an OpenID server endpoint.' and return
    end

    unless req.kind_of?(CheckIDRequest)
      render_response(server.handle_request(req)) and return
    end

    req
  end

  def is_authorized?(req, user)
    if req.id_select or (u = User.find_by_openid(req.identity) and u.id == user.id)
      user.openid_trusts.find_by_trust_root(req.trust_root)
    else
      false
    end
  end

  def authorize!(req, user)
    resp = req.answer(true, nil, req.id_select ? user.openid_identity : req.identity)
    add_sreg(user, req, resp)
    add_pape(user, req, resp)
    render_response(resp)
  end

  def encode_params(params)
    data = ActiveSupport::Base64.encode64(Marshal.dump(params)).chop 
    "#{data}--#{generate_digest(data)}"
  end

  def decode_params(string)
    data, digest = string.to_s.split('--')
    Marshal.load(ActiveSupport::Base64.decode64(data)) if digest.to_s == generate_digest(data)
  end

  def generate_digest(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('SHA1'), APP_CONFIG['openid']['secret'], data.to_s)
  end
end
