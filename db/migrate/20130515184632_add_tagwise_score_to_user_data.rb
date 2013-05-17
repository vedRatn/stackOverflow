class AddTagwiseScoreToUserData < ActiveRecord::Migration
  def change
    add_column :user_data, :tagwise_score, :text
  end
end
