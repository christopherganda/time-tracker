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

  context '#followings_sleep_records' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:non_followed_user) { create(:user) }
    now = Time.now

    let!(:follow_relationship) do
      create(:user_follow, follower: user, followee: followed_user)
    end

    let!(:recent_sleep_record) do
      create(
        :sleep_record,
        user: followed_user,
        clocked_in_at: now - 3.days,
        clocked_out_at: now - 2.days
      )
    end

    let!(:old_sleep_record) do
      create(
        :sleep_record,
        user: followed_user,
        clocked_in_at: now - 10.days,
        clocked_out_at: now - 9.days
      )
    end

    let!(:invalid_sleep_record) do
      create(
        :sleep_record,
        user: non_followed_user,
        clocked_in_at: now - 3.days,
        clocked_out_at: now - 2.days
      )
    end

    it 'returns followings sleep records of the past week' do
      result = user.followings_sleep_records

      expect(result.size).to eq(1)
      expect(result.first.followee_id).to eq(followed_user.id)
      expect(result.first.sleep_length).to eq(1.day)
      expect(result.first.clocked_in_at).to eq(recent_sleep_record.clocked_in_at)
      expect(result.first.clocked_out_at).to eq(recent_sleep_record.clocked_out_at)
    end

    it 'will not return sleep records beyond 7 days and non following user' do
      result = user.followings_sleep_records

      expect(result).not_to include(old_sleep_record)
      expect(result).not_to include(invalid_sleep_record)
    end

    it 'orders the results by sleep length descending' do
      create(
        :sleep_record,
        user: followed_user,
        clocked_in_at: now - 4.days,
        clocked_out_at: now - 2.days
      )

      result = user.followings_sleep_records
      sleep_lengths = result.map(&:sleep_length)

      expect(sleep_lengths).to eq(sleep_lengths.sort.reverse)
    end
  end

end