class AddIndexToMaxScoreDataSkill < ActiveRecord::Migration
  def change
  	add_index :max_score_data, :skill, unique: true
  end
end
