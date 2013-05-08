class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :about_me
      t.string :location
      t.string :website_url
      t.string :reputation
      t.string :skills

      t.timestamps
    end
  end
end
