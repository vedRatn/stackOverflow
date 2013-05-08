class AddUpVotesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :up_votes, :integer
  end
end
