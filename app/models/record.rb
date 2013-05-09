class Record < ActiveRecord::Base
  attr_accessible :bool, :user_id

  validates :user_id, presence: true, uniqueness: { case_sensitive: false }
end
