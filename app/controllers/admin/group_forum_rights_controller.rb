class Admin::GroupForumRightsController < Admin::ApplicationController
  layout 'admin'
  active_scaffold do |config|
    config.columns.exclude :created_at

    [ :forum, :group ].each do |f|
      config.columns[f].form_ui = :select
    end

    [ :is_read, :is_post, :is_reply, :is_edit, :is_topic_moderate, :is_moderate ].each do |f|
      config.columns[f].form_ui = :checkbox
    end

    config.list.columns   = \
    config.create.columns = \
    config.update.columns = [:group, :forum, :is_read, :is_post, :is_reply, :is_edit, :is_topic_moderate, :is_moderate]
  end
end
