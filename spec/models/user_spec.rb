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

  context 'relationship with clock ins' do
    let!(:user1) { User.create!(name: "test1") }
    before do
      ClockIn.create!(
        user_id: user1.id,
        clocked_in_at: Time.now
      )
    end

    it "has 1 clock in record" do
      clock_in = ClockIn.where(user_id: user1.id)
                .order(clocked_in_at: :desc)
                .limit(7)
                .pluck(:clocked_in_at, :is_clocked_out)
      expect(user1.clock_ins).to eq(clock_in)

      clock_in_json = clock_in.map do |clocked_in_at, is_clocked_out|
        {
          clocked_in_at: clocked_in_at.strftime("%Y-%m-%d %H:%M:%S"),
          is_clocked_out: is_clocked_out
        }
      end
      expect(user1.clock_ins_json).to eq(clock_in_json)
    end
  end

end