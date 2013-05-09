class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :query
      t.string :user_ids

      t.timestamps
    end
  end
end
