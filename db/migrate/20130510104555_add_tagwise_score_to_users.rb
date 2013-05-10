class AddTagwiseScoreToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :tagwise_score, :text
  end
end
