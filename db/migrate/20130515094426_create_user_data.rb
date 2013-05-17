class CreateUserData < ActiveRecord::Migration
  def change
    create_table :user_data do |t|
      t.integer :page
      t.text :user

      t.timestamps
    end
  end
end
