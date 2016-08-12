class CreateUpvoteTable < ActiveRecord::Migration
  def change
    create_table :upvotes do |column|
      column.belongs_to :user
      column.belongs_to :song
    end
  end
end
