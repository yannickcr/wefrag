class Admin::CategoriesController < Admin::ApplicationController
  layout 'admin'
  active_scaffold do |config|
    config.columns.exclude :created_at

    config.actions.exclude :search
    config.columns[:title].set_link :edit

    config.list.columns   = \
    config.create.columns = \
    config.update.columns = [:title, :position]
    config.list.columns.add :forums
  end
end
