require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let!(:user1) { User.create!(name: "test1") }
  let!(:clock_in1) { ClockIn.create!(user_id: user1.id, clocked_in_at: Time.now.getutc, is_clocked_out: false)}
  
  context 'validations' do
    it 'succeed' do
      sleep_record = SleepRecord.new(
        user_id: user1.id, 
        clock_in_id: clock_in1.id, 
        clocked_in_at: clock_in1.clocked_in_at, 
        clocked_out_at: clock_in1.clocked_in_at + 1.hour)
      expect(sleep_record).to be_valid
    end
  
    it 'does not have valid clock_in' do
      sleep_record = SleepRecord.new(
        user_id: user1.id, 
        clock_in_id: clock_in1.id+100, 
        clocked_in_at: clock_in1.clocked_in_at, 
        clocked_out_at: clock_in1.clocked_in_at + 1)
      expect(sleep_record).not_to be_valid
    end
  end
end