class CreateSongTable < ActiveRecord::Migration
  def change
    create_table :songs do |column|
      column.string :title
      column.string :author
      column.string :url
      column.timestamps
    end
  end
end
