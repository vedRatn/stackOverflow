class AddValueToUserData < ActiveRecord::Migration
  def change
    add_column :user_data, :value, :float
  end
end
