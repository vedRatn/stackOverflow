class User < ActiveRecord::Base
  attr_accessible :about_me, :location, :name, :reputation, :skills, :website_url, :site_id, :profile_image, :up_votes, :down_votes, :badges, :question, :answer

  validates :name, presence: true, length: { maximum: 50 }
end
