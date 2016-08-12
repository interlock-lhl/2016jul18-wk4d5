class User < ActiveRecord::Base

  has_many :songs
  has_many :upvotes

  validates :username,
    presence: true,
    uniqueness: true,
    length: {
      minimum: 3,
      maximum: 24
    }
  validates :password,
    presence: true,
    length: {
      minimum: 8,
      maximum: 24
    }
  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
      message: "must be a proper email format!"
    }

end