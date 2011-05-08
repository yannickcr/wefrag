module TopicsHelper
  def topic_icon(topic, user)
    icon = [] 
    icon << 'locked' if topic.is_locked?
    icon << 'unread' unless topic.is_read_by?(user)
    icon.join '_'
  end

  def topic_menu(topic, user)
    return 'Actions' unless user
    html = []
    html << '<ul class="sf-menu">'
    html << '<li class="current">' + link_to('Actions', forum_topic_path(topic.forum, topic), :class => :current)
    html << '<ul>'
    html << '<li>' + link_to(label = 'Marquer comme lu', read_forum_topic_path(topic.forum, topic), :title => label, :class => :read) + '</li>' unless topic.is_read_by?(user)
    html << '<li>' + link_to(label = topic.is_read_forever_by?(user) ? 'Ne plus lire pour toujours' : 'Lire pour toujours', read_forever_forum_topic_path(topic.forum, topic), :title => label, :class => :read) + '</li>'
    html << '</ul>'
    html << '</li>'
    html << '</ul>'
    html.join "\n"
  end

  def topic_actions(forum, topic, user)
    html = []
    html << link_to(label = 'Répondre', new_forum_topic_post_path(forum, topic), :title => label, :class => :reply) if !user || topic.can_reply?(user)
    html << link_to(label = topic.is_locked? ? 'Déverrouiller' : 'Verrouiller', lock_forum_topic_path(forum, topic), :method => :post, :title => label, :class => topic.is_locked? ? :locked : :unlocked) if topic.can_lock?(user)
    html << link_to(label = topic.is_sticky? ? 'Pas important' : 'Important', stick_forum_topic_path(forum, topic), :method => :post, :title => label, :class => topic.is_sticky? ? :sticky : :unsticky) if forum.can_moderate?(user)
    html << link_to(label = 'Déplacer', move_forum_topic_path(forum, topic), :title => label, :class => :move) if can_admin?
    html.join ' '
  end

  def topic_title(forum, topic)
    html  = ''
    html += content_tag(:strong, 'Important : ') if topic.is_sticky
    html += link_to h(topic), forum_topic_path(forum, topic)
  end

  def topic_last_post(topic)
    topic.last_post.created_at.strftime('%d/%m/%Y à %Hh%M') +
    ' par ' + content_tag(:span, h(topic.last_post.user), :class => :login)
  end

  def to_post_path(forum, topic, post)
    params = post.is_topic? ? {} : { :page => post.page, :anchor => "post_#{post.id}" }
    forum_topic_path forum, topic, params
  end

  def show_topic_spent_time(topic, user)
    if user
      time_spent = topic.time_spent_by(user)
      content_tag(:span, "#{distance_of_time_in_words(time_spent)} passé sur ce sujet", :class => :spent_time) if time_spent > 0
    end
  end
end
