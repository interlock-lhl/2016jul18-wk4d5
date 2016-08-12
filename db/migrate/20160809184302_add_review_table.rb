class AddReviewTable < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :content
      t.belongs_to :user
      t.belongs_to :song
      t.timestamps
    end
  end
end
