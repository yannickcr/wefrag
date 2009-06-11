class Admin::ForumsController < Admin::ApplicationController
  layout 'admin'
  active_scaffold do |config|
    config.columns.exclude :rights, :created_at

    config.actions.exclude :search
    config.columns[:title].set_link :edit
    config.columns[:category].form_ui = :select

    config.list.columns   = \
    config.create.columns = \
    config.update.columns = [:title, :stripped_title, :description, :category, :position]
    config.list.columns.remove :description
  end
end
