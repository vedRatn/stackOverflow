class AddRawScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :raw_score, :text
  end
end
