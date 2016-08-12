require 'json'

helpers do
  def serialize_review(review)
    r = review.attributes
    r["user"] = review.user.attributes
    r["user"].delete("password")
    r
  end
end

namespace '/api' do
  # Songs
  namespace '/songs' do

    namespace '/:song_id/reviews' do
      get '' do
        mapped = Review.where(song_id: params[:song_id]).includes(:user).all.map do |review|
          serialize_review(review)
        end
        json mapped
      end

      post do
        review_data = JSON.parse(request.env["rack.input"].read)
        user = current_user
        review = Review.new(review_data)
        review.user_id = user.id
        review.song_id = params[:song_id]
        if review.save
          json(serialize_review(review))
        else
          json({errors: review.errors}, statusCode: 422)
        end
      end
    end
  end


  # Upvotes
  namespace '/upvotes' do

    # song_id
    post '' do
      user = current_user
      upvote = Upvote.new(user_id: user.id, song_id: params[:song_id])
      action = "up"
      unless upvote.save
        existing_upvote = Upvote.find_by(user_id: user.id, song_id: params[:song_id])
        action = "down"
        existing_upvote.destroy
      end
      count = Song.find(params[:song_id]).upvotes.count
      json({ upvotes: count, action: action})
      # { "upvotes": 1 }
    end
  end
end
