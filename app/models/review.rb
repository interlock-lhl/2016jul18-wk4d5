class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :song

  validates :content,
    presence: true
  validates :rating,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5
    }
  validates :user_id,
    presence: true,
    uniqueness: {
      scope: :song_id
    }
  validates :song_id,
    presence: true
  
end