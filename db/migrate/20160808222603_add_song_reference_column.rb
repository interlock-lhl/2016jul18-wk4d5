class AddSongReferenceColumn < ActiveRecord::Migration
  def change
    change_table :songs do |column|
      column.references :user
    end
  end
end
