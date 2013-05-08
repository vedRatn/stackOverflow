class AddBadgesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :badges, :string
  end
end
