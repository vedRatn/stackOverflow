class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.boolean :bool

      t.timestamps
    end
  end
end
