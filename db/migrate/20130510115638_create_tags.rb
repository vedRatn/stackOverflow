class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag
      t.text :synonyms

      t.timestamps
    end
  end
end
