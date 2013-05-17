class CreateRemovedTags < ActiveRecord::Migration
  def change
    create_table :removed_tags do |t|
      t.string :tag
      t.text :synonyms

      t.timestamps
    end
  end
end
