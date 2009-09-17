ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'forums', :action => 'home'

  # Admin
  map.namespace :admin do |admin|
    [ :categories, :forums, :groups, :group_forum_rights ].each do |item|
      admin.resources item, :active_scaffold => true
    end
    admin.resources :users, :member => { :confirm => :any }, :active_scaffold => true
  end

  # User(s)
  map.resource :user, :controller => 'user'

  map.namespace :user do |user|
    user.resource  :session,  :except => [:edit, :update]
    user.resources :password, :except => [:edit, :update, :destroy]
  end

  map.with_options :controller => 'user', :requirements => { :code => /[a-f0-9]{32,64}/ } do |user|
    user.confirm_user 'user/:code',        :action => 'confirm'
    user.cancel_user  'user/:code/cancel', :action => 'cancel'
  end

  map.show_user 'users/:id', :controller => 'users', :action => 'show', :requirements => { :id => /[a-zA-Z0-9_\-]+/ }


  # Search
  map.with_options :controller => 'search', :action => 'new' do |s|
    s.searches   'search', :conditions => { :method => :post }, :action => 'create'
    s.searches   'search'
    s.new_search 'search'
    s.search     'search/:s/:page', :action => 'show', :requirements => { :s => /[^\/]+/, :page => /[1-9]\d*/ }, :defaults => { :page => 1 }
  end

  # Forum
  map.resources :forums, :only => [ :index, :show ], :collection => { :read_all => :any }, :member => { :read => :any } do |forum|
    forum.resources :topics, :member => { :quote => :get, :stick => :post, :lock => :post, :move => :any, :read => :any, :read_forever => :any } do |topic| 
      topic.resources :posts, :except => [ :index ], :member => { :quote => :get }
    end
  end

  map.resources :topics, :only => :timetrack, :member => { :timetrack => :post }

  map.ban_forum_topic 'forums/:forum_id/topics/:id/ban/:user_id', :controller => 'topics', :action => 'ban', :requirements => { :forum_id => /[a-zA-Z0-9_\-]+/, :id => /[1-9]\d*/, :user_id => /[1-9]\d*/ }, :conditions => { :method => :post }
  map.preview_post 'posts/preview', :controller => 'posts', :action => 'preview'

  # Forum pagination
  map.with_options :controller => 'forums', :action => 'show', :requirements => { :id => /[a-zA-Z0-9_\-]+/, :page => /[1-9]\d*/ } do |forum|
    forum.forum 'forums/:id/:page', :defaults => { :page => 1 }
  end
  map.forum_topic 'forums/:forum_id/topics/:id/:page', :controller => 'topics', :action => 'show', :requirements => { :forum_id => /[a-zA-Z0-9_\-]+/, :id => /[1-9]\d*/, :page => /[1-9]\d*/ }, :defaults => { :page => 1 }

  map.resources :nofrag, :only => :show

  # Shout
  map.resources :shouts, :only => [ :index, :new, :create ], :collection => { :box => :get }
  map.shouts_page 'shouts/page/:page', :controller => 'shouts', :action => 'index', :requirements => { :page => /[1-9]\d*/ }, :defaults => { :page => 1 }

  map.with_options :controller => 'openid' do |openid|
    openid.openid_server 'openid',        :action => 'index'
    openid.openid_info   'openid/xrds',   :action => 'info', :format => 'xrds'
    openid.openid_decide 'openid/decide', :action => 'decide'
  end
end
