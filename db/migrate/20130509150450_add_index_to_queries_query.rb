class AddIndexToQueriesQuery < ActiveRecord::Migration
  def change
  	add_index :queries, :query, unique: true
  end
end
