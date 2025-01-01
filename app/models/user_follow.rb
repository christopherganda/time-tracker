class UserFollow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followee_id, message: "This user has been followed" }

  validate :following_self

  private

  def following_self
    if follower_id == followee_id
      errors.add(:follower, :blank, message: "cannot be the same as Followee")
    end
  end
end