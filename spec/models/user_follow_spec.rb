require 'rails_helper'

RSpec.describe UserFollow, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  describe 'validations' do
    context 'check uniqeness' do
      it 'allows valid follow relationships' do
        follow = UserFollow.new(follower_id: user1.id, followee_id: user2.id)
        expect(follow).to be_valid
      end
  
      it 'does not allow duplication of follower_id and followee_id' do
        UserFollow.create(follower_id: user1.id, followee_id: user2.id)
        duplicate = UserFollow.new(follower_id: user1.id, followee_id: user2.id)
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:follower_id]).to include(I18n.t('activerecord.errors.has_been_followed'))
      end
    end

    context 'check following self' do
      it 'does not allow following themselves' do
        follow = UserFollow.new(follower_id: user1.id, followee_id: user1.id)
        expect(follow).not_to be_valid
        expect(follow.errors.full_messages).to include(I18n.t('activerecord.errors.following_self_with_param', param: 'Follower'))
      end
    end
  end
end