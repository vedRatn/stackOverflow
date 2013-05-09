class Query < ActiveRecord::Base
  attr_accessible :query, :user_ids

  before_save { |q| q.query = query.downcase }

  validates :query, presence: true, uniqueness: { case_sensitive: false }
end
