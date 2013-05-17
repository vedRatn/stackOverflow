class AddUserIdToUserData < ActiveRecord::Migration
  def change
    add_column :user_data, :user_id, :integer
  end
end
