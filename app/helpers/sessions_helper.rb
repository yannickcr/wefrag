module SessionsHelper
  def username_from_openid
    matches = params['openid.identity'].match /\/users\/(.+)/
    matches[1] if matches[1]
  end

  def url_for_user
    url_for :controller => 'user', :action => session[:username]
  end
end
