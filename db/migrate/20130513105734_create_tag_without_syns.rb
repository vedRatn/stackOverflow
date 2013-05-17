class CreateTagWithoutSyns < ActiveRecord::Migration
  def change
    create_table :tag_without_syns do |t|
      t.string :tag
      t.text :synonyms

      t.timestamps
    end
  end
end
