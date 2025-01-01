require 'rails_helper'

RSpec.describe User, type: :model do

  it 'succeed' do
    user = User.new(name: "test1")
    expect(user).to be_valid
  end

  context 'relationship with UserFollows' do
    let!(:user1) { User.create!(name: "test1") }
    let!(:user2) { User.create!(name: "test2") }
    before do
      UserFollow.create(follower_id: user1.id, followee_id: user2.id)
    end

    it "user1 has valid followings" do
      expect(user1.following_ids).to include(user2.id)
      expect(user1.followings).to include(user2.name)
    end

    it "user1 doesn't have followers" do
      expect(user1.follower_ids).to eq([])
      expect(user1.followers).to eq([])
    end

    it "user2 doesn't have followings" do
      expect(user2.following_ids).to eq([])
      expect(user2.followings).to eq([])
    end

    it "user2 have followers" do
      expect(user2.follower_ids).to include(user1.id)
      expect(user2.followers).to include(user1.name)
    end
  end

end