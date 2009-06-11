class Admin::ApplicationController < ApplicationController
  before_filter :admin_required!

  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add :topics, :posts, :last_post, :last_reply, :reads, :updated_at
  end
end
