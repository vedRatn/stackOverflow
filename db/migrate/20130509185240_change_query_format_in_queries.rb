class ChangeQueryFormatInQueries < ActiveRecord::Migration
  def up
  	change_column :queries, :user_ids, :text
  end

  def down
  	change_column :queries, :user_ids, :string
  end
end
