class FinalTags < ActiveRecord::Base
  attr_accessible :super, :synonyms, :tag

  validates :tag, presence: true, uniqueness: { case_sensitive: false }
end
