ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'forums', :action => 'home'

  # Admin
  map.namespace :admin do |admin|
    [ :categories, :forums, :groups, :group_forum_rights ].each do |item|
      admin.resources item, :active_scaffold => true
    end
    admin.resources :users, :member => { :confirm => :any }, :active_scaffold => true
  end

  # User
  map.resource :session, :except => [ :edit, :update ]

  map.resource :user, :controller => 'user'
  map.with_options :controller => 'user', :requirements => { :code => /[a-f0-9]{32,64}/ } do |user|
    user.confirm_user 'user/:code',        :action => 'confirm'
    user.cancel_user  'user/:code/cancel', :action => 'cancel'
  end

  map.with_options :controller => 'users', :action => 'show', :requirements => { :id => /[a-zA-Z0-9_\-]+/ } do |user|
    user.show_user            'users/:id'
    user.show_user_formatted  'users/:id.:format'
  end

  # Search
  map.with_options :controller => 'search', :action => 'new' do |s|
    s.searches   'search', :conditions => { :method => :post }, :action => 'create'
    s.searches   'search'
    s.new_search 'search'
    s.search     'search/:s/:page', :action => 'show', :requirements => { :s => /[^\/]+/, :page => /[1-9]\d*/ }, :defaults => { :page => 1 }
  end

  # Forum
  map.resources :forums, :only => [ :index, :show ], :collection => { :read_all => :any }, :member => { :read => :any }, :requirements => { :id => /[a-zA-Z0-9_\-]+/ } do |f|
    f.with_options :requirements => { :forum_id => /[a-zA-Z0-9_\-]+/, :id => /[1-9]\d*/ } do |forum|
      forum.resources :topics, :member => { :quote => :get, :stick => :post, :lock => :post, :move => :any, :read => :any, :read_forever => :any } do |topic| 
        topic.resources :posts, :member => { :quote => :get }, :requirements => { :topic_id => /[1-9]\d*/ }
      end
    end
  end
  map.ban_forum_topic 'forums/:forum_id/topics/:id/ban/:user_id', :controller => 'topics', :action => 'ban', :method => :post, :requirements => { :forum_id => /[a-zA-Z0-9_\-]+/, :id => /[1-9]\d*/, :user_id => /[1-9]\d*/ }, :conditions => { :method => :post }
  map.preview_post 'posts/preview', :controller => 'posts', :action => 'preview'


  # Forum pagination
  map.with_options :controller => 'forums', :action => 'show', :requirements => { :id => /[a-zA-Z0-9_\-]+/, :page => /[1-9]\d*/ } do |forum|
    forum.forum 'forums/:id/:page', :defaults => { :page => 1 }
    forum.formatted_forum 'forums/:id/:page.:format'
  end
  map.forum_topic 'forums/:forum_id/topics/:id/:page', :controller => 'topics', :action => 'show', :requirements => { :forum_id => /[a-zA-Z0-9_\-]+/, :id => /[1-9]\d*/, :page => /[1-9]\d*/ }, :defaults => { :page => 1 }

  map.resources :nofrag, :only => :show


  # Shout
  map.resources :shouts, :requirements => { :id => /[1-9]\d*/ }, :except => [ :edit, :update ], :collection => { :box => :any }
  map.shouts_page 'shouts/page/:page', :controller => 'shouts', :action => 'index', :requirements => { :page => /[1-9]\d*/ }, :defaults => { :page => 1 }

  map.with_options :controller => 'openid' do |openid|
    openid.openid_server 'openid',        :action => 'index'
    openid.openid_info   'openid/xrds',   :action => 'info', :format => 'xrds'
    openid.openid_decide 'openid/decide', :action => 'decide'
  end
end
