class UserFollow < ApplicationRecord
  belongs_to :follower, class_name: 'User', optional: true
  belongs_to :followee, class_name: 'User', optional: true

  validates :follower_id, uniqueness: { scope: :followee_id, message: I18n.t('activerecord.errors.has_been_followed') }

  validate :following_self

  private

  def following_self
    if follower_id == followee_id
      errors.add(:follower, :blank, message: I18n.t('activerecord.errors.following_self'))
    end
  end
end