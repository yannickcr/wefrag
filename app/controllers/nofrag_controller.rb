class NofragController < ApplicationController
  def news
    item = ImportedNofragItem.posted.find_by_remote_id(params[:id]) or raise ActiveRecord::RecordNotFound
    redirect_to forum_topic_url(item.topic.forum, item.topic)
  end
end
