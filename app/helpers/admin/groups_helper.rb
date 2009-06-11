module Admin::GroupsHelper
  def rights_column(record)
    rights = record.rights(:include => :forum)
    rights.empty? ? '-' : rights.collect { |r| r.forum }.join(', ')
  end
end
