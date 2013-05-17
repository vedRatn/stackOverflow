class CreateTagWithSyns < ActiveRecord::Migration
  def change
    create_table :tag_with_syns do |t|
      t.string :tag
      t.text :synonyms

      t.timestamps
    end
  end
end
