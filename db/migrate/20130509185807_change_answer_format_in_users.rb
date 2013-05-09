class ChangeAnswerFormatInUsers < ActiveRecord::Migration
   def up
  	change_column :users, :answer, :text
  end

  def down
  	change_column :users, :answer, :string
  end
end
