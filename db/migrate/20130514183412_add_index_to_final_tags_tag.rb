class AddIndexToFinalTagsTag < ActiveRecord::Migration
  def change
  	add_index :final_tags, :tag, unique: true
  end
end
