class AddIndexToTagsTag < ActiveRecord::Migration
  def change
  	add_index :tags, :tag, unique: true
  end
end
