class TagWithoutSyns < ActiveRecord::Base
  attr_accessible :synonyms, :tag

  validates :tag, presence: true, uniqueness: { case_sensitive: false }
end
