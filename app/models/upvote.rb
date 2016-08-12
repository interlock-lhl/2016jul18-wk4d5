class Upvote < ActiveRecord::Base

  belongs_to :user
  belongs_to :song

  validates :user_id,
    presence: true
  validates :song_id,
    presence: true,
    uniqueness: {
      scope: :user_id
    } 

  after_save do
    self.song.check_upvotes
  end

  after_destroy do 
    self.song.check_upvotes
  end
end