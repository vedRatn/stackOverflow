class AddDownVotesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :down_votes, :integer
  end
end
