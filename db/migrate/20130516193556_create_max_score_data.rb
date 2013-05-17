class CreateMaxScoreData < ActiveRecord::Migration
  def change
    create_table :max_score_data do |t|
      t.string :skill
      t.integer :score
      t.integer :user_id

      t.timestamps
    end
  end
end
