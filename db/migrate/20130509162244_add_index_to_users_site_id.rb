class AddIndexToUsersSiteId < ActiveRecord::Migration
  def change
  	add_index :users, :site_id, unique: true
  end
end
