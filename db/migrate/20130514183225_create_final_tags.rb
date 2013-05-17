class CreateFinalTags < ActiveRecord::Migration
  def change
    create_table :final_tags do |t|
      t.string :tag
      t.text :synonyms
      t.text :super

      t.timestamps
    end
  end
end
