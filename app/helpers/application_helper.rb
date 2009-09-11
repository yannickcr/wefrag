module ApplicationHelper
  def can_admin?
    logged_in? and current_user.can_admin?
  end

  def is_user_active?
    logged_in? and current_user.active?
  end

  def format_text(text)
    white_list auto_link(bbcodeize(h(text))).gsub(/\r\n?/, "\n").gsub("\n", '<br />')
  end

  def text_with_links(text)
    white_list(auto_link(h(text)) { '[url]' })
  end

  def flash_messages
    result = []
    [:notice, :warning, :message].each do |type|
      result << content_tag(:div, flash[type], :class => type) if flash[type]
    end
    content_tag(:div, result.join, :id => :flash) unless result.empty?
  end

  def can_read?(forum)
    forum.can_read?(current_user)
  end

  def h_or_blank(text, placeholder='&nbsp;')
    text.blank? ? placeholder : h(text)
  end

  def styles_and_scripts
    html = []
    html << stylesheet_link_tag('screen', 'forums', 'markitup/style.css', 'markitup/sets/bbcode/style.css', 'superfish.css', :cache => true)
    html << '<!--[if IE]>' + stylesheet_link_tag('ie') + '<![endif]-->'
    html << javascript_include_tag('jquery.min.js', 'jquery.noconflict.js', 'jquery.form.js', 'jquery.markitup.js', 'jquery.simplemodal.min.js', 'markitup/sets/bbcode/set.js', 'application', 'hoverIntent', 'superfish', 'prototype', 'time_tracker', :cache => true)
    html.join "\n"
  end
end
