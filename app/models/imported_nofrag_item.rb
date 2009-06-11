class ImportedNofragItem < ActiveRecord::Base
  belongs_to  :topic
  named_scope :posted,   :conditions => [ 'topic_id IS NOT NULL' ]
  named_scope :unposted, :conditions => [ 'topic_id IS NULL' ]
end
