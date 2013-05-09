class AddIndexToRecordsUserId < ActiveRecord::Migration
  def change
  	add_index :records, :user_id, unique: true
  end
end
