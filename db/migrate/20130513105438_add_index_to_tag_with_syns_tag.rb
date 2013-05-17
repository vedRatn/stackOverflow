class AddIndexToTagWithSynsTag < ActiveRecord::Migration
  def change
  	add_index :tag_with_syns, :tag, unique: true
  end
end
