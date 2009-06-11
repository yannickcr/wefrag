class UserInfo < ActiveRecord::Base
  belongs_to :user

  attr_accessible :steam_id, :xboxlive_id, :psn_id,
                  :job, :website, :is_email

  validates_length_of :website,     :maximum => 100, :allow_blank => true, :allow_nil => true
  validates_length_of :job,         :maximum => 100, :allow_blank => true, :allow_nil => true
  validates_length_of :steam_id,    :maximum => 50, :allow_blank => true, :allow_nil => true
  validates_length_of :xboxlive_id, :maximum => 50, :allow_blank => true, :allow_nil => true
  validates_length_of :psn_id,      :maximum => 50, :allow_blank => true, :allow_nil => true

  validates_inclusion_of :is_email, :in => [true, false]
end
