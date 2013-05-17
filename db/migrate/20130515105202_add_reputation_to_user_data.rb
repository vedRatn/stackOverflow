class AddReputationToUserData < ActiveRecord::Migration
  def change
    add_column :user_data, :reputation, :integer
  end
end
