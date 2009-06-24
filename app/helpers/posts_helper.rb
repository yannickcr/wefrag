module PostsHelper
  def post_class(topic, post, user)
    topic.is_read_by?(user, post) ? '' : ' unread'
  end

  def post_actions(forum, topic, post, user)
    if post.new_record?
      path = forum_topic_path(forum, topic, :page => topic.last_page)
    else
      path = to_post_path(forum, topic, post)
    end
    link_to 'Annuler', path
  end

  def post_edit(forum, topic, post, user)
    if post.is_topic?
      edit_path    = edit_forum_topic_path(forum, post)
      destroy_path = forum_topic_path(forum, post)
      quote_path   = quote_forum_topic_path(forum, post)
    else
      edit_path    = edit_forum_topic_post_path(forum, topic, post)
      destroy_path = forum_topic_post_path(forum, topic, post)
      quote_path   = quote_forum_topic_post_path(forum, topic, post)
    end

    html = []

    if topic.can_reply?(user)
      html << link_to('Citer', quote_path)
    end

    if post.can_edit?(user)
      html << link_to('Modifier', edit_path)
    end

    if post.can_delete?(user)
      html << link_to('Supprimer', destroy_path, :method => :delete, :confirm => 'Êtes-vous sûr de vouloir supprimer ce message ?')
    end

    if topic.can_ban?(user) and user.id != post.user.id
      html << link_to((post.user.is_banned?(topic) ? 'Débannir du sujet' : 'Bannir du sujet'), ban_forum_topic_path(forum, topic, post.user.id), :method => :post)
    end

    html.join ' '
  end

  def post_date(post)
    post.created_at.strftime("<strong>%Hh%M</strong> #{post.created_at.to_date == Date.today ? 'aujourd\'hui' : 'le %d/%m/%Y'}") if post
  end

  def post_summary(post)
    post_date(post) + ' par ' + content_tag(:span, user_login(post.user), :class => :user) if post
  end
end
