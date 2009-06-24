class Category < ActiveRecord::Base
  default_scope :order => '`categories`.position ASC'
  acts_as_list

  has_many :forums

  attr_accessible :title
  validates_length_of :title, :in => 3..50

  def to_s
    "#{title}"
  end

  def self.all_with_forums
    Rails.cache.fetch "Category.all_with_forums", :expires_in => 5.minutes do
      find :all, :include => :forums
    end
  end
end
