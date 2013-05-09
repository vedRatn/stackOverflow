class ChangeQuestionFormatInUsers < ActiveRecord::Migration
  def up
  	change_column :users, :question, :text
  end

  def down
  	change_column :users, :question, :string
  end
end
