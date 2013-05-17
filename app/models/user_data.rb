class UserData < ActiveRecord::Base
  attr_accessible :page, :user, :reputation

  default_scope order('reputation DESC')
end
