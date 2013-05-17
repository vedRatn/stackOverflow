class MaxScoreData < ActiveRecord::Base
  attr_accessible :score, :skill, :user_id
  validates :skill, presence: true, uniqueness: { case_sensitive: false }
end
