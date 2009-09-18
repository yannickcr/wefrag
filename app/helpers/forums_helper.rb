module ForumsHelper
  def forum_icon(forum, user)
    if !forum.can_read?(user)
      'disabled'
    elsif forum.is_read_by?(user)
      'read'
    else
      'unread'
    end
  end

  def forums_actions(user)
    html = []
    if user
      html << link_to('Déconnexion', my_session_path, :method => :delete)
    end
    html << link_to('Rechercher', new_search_path)
    if user
      html << link_to('Tout lu', read_all_forums_path, :class => :read)
      html << link_to('Administration', admin_forums_path, :class => :admin) if user.can_admin?
      html << link_to(h(truncate(user.login, :length => 15)), user_path, :class => :user)
    else
      html << link_to('Identification', new_my_session_path, :class => :new_my_session)
      html << link_to('Ouvrir un compte', new_user_path)
    end
    html.join ' '
  end

  def forum_actions(forum, user)
    html = []
    html << link_to('Nouveau sujet', new_forum_topic_path(forum)) if !user || forum.can_post?(user)
    html << link_to(label = 'Tout lu', read_forum_path(forum), :title => label, :class => :read)
    html << link_to('Weplay', 'http://play.wefrag.com') if forum.is_weplay?
    html.join ' '
  end

  def breadcrumb(forum = nil, topic = nil, post = nil, text = nil)
    html = [ link_to('Forums', forums_path) ]
    if forum
      html << link_to(h(forum.to_s), forum_path(forum))
      if topic
        html << (topic.new_record? ? 'Nouveau sujet' : link_to(h(topic.to_s), forum_topic_path(forum, topic)))
        html << 'Répondre' if post && post.new_record?
      end
    end
    html << text if text
    content_tag :div, html.join(' &raquo; '), :class => :breadcrumb
  end

  def user_login(user)
    link_to(h(user), show_user_path(user)) if user
  end

  def show_shouts_box
    render :partial => 'shouts/box', :locals => { :shouts => Shout.all(:limit => 20) }
  end
end
