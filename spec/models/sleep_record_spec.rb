require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  context 'validations' do
    let!(:user1) { User.create!(name: "test1") }
    let!(:clock_in1) { ClockIn.create!(user_id: user1.id, clocked_in_at: Time.now, is_clocked_out: false)}

    it 'succeed' do
      sleep_record = SleepRecord.new(
        user_id: user1.id, 
        clock_in_id: clock_in1.id, 
        clocked_in_at: clock_in1.clocked_in_at, 
        clocked_out_at: clock_in1.clocked_in_at + 1.hour)
      expect(sleep_record).to be_valid
    end
  end

  context 'callbacks' do
    let!(:user1) { User.create!(name: "test1") }
    let!(:clock_in1) { ClockIn.create!(user_id: user1.id, clocked_in_at: Time.now, is_clocked_out: false)}

    it 'update clock ins to true' do
      SleepRecord.create(
        user_id: user1.id,
        clock_in_id: clock_in1.id,
        clocked_in_at: clock_in1.clocked_in_at,
        clocked_out_at: Time.now
      )
      clock_in1.reload
      expect(clock_in1.is_clocked_out).to eq(true)
    end
  end
end