xml.instruct! :xml, :version => 1.0, :encoding => 'UTF-8'
xml.markers do
  @users.each do |user|
    xml.marker :address => user.address
  end
end
