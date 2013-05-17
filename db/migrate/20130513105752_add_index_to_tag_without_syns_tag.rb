class AddIndexToTagWithoutSynsTag < ActiveRecord::Migration
  def change
  	add_index :tag_without_syns, :tag, unique: true
  end
end
