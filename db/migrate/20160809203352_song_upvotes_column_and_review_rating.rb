class SongUpvotesColumnAndReviewRating < ActiveRecord::Migration
  def change
    change_table :songs do |t|
      t.integer :num_upvotes, default: 0
    end

    change_table :reviews do |t|
      t.integer :rating
    end
  end
end
