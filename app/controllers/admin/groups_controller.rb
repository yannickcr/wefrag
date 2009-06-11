class Admin::GroupsController < Admin::ApplicationController
  layout 'admin'
  active_scaffold do |config|
    config.columns.exclude :created_at

    config.columns[:title].set_link :edit
    config.columns[:rights].label = 'Rights for forum'

    config.list.columns   = \
    config.create.columns = \
    config.update.columns = [:title, :rights]
  end
end
