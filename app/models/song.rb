class Song < ActiveRecord::Base

  belongs_to :user
  has_many :upvotes
  has_many :reviews

  validates :title,
    presence: true,
    uniqueness: true
  validates :author,
    presence: true
  validates :url,
    allow_blank: true,
    format: {
      with: URI.regexp,
      message: "must be a valid url!"
    }

  def check_upvotes
    self.update_column(:num_upvotes, self.upvotes.size)
  end

end
