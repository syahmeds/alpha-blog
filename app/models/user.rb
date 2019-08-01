class User < ActiveRecord::Base

  has_many :articles, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { self.email = email.downcase }

  validates :username, presence: true,

            uniqueness: { case_sensitive: false },

            length: { minimum: 3, maximum: 25 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 105 },

            uniqueness: { case_sensitive: false },

            format: { with: VALID_EMAIL_REGEX }

  has_secure_password

  # helper methods

  # follow another user
  def follow(other)
    active_relationships.create(followed_id: other.id)
  end

  # unfollow a user
  def unfollow(other)
    active_relationships.find_by(followed_id: other.id).destroy
  end

  # is following a user?
  def following?(other)
    following.include?(other)
  end

end