require 'rails_helper'

RSpec.describe UserFollow, type: :model do
  let!(:user1) { User.create!(name: "test1") }
  let!(:user2) { User.create!(name: "test2") }

  context "validations" do
    it "follower_id does not exist in user" do
      follow = UserFollow.new(follower_id: user1.id+100, followee_id: user2.id)
      expect(follow).not_to be_valid
    end

    it "followee_id does not exist in user" do
      follow = UserFollow.new(follower_id: user1.id, followee_id: user2.id+100)
      expect(follow).not_to be_valid
    end

    it "allows valid follow relationships" do
      follow = UserFollow.new(follower_id: user1.id, followee_id: user2.id)
      expect(follow).to be_valid
    end

    it "does not allow duplication of follower_id and followee_id" do
      UserFollow.create(follower_id: user1.id, followee_id: user2.id)
      duplicate = UserFollow.new(follower_id: user1.id, followee_id: user2.id)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:follower_id]).to include("This user has been followed")
    end

    it "does not allow following themselves" do
      follow = UserFollow.new(follower_id: user1.id, followee_id: user1.id)
      expect(follow).not_to be_valid
      expect(follow.errors.full_messages).to include("Follower cannot be the same as Followee")
    end
  end
end