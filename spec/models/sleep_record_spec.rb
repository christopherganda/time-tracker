require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  context 'creation' do
    let!(:user1) { create(:user) }
    let!(:clock_in1) do
      create(:clock_in, user: user1)
    end

    it 'succeed' do
      sleep_record = SleepRecord.new(
        user_id: user1.id, 
        clock_in_id: clock_in1.id, 
        clocked_in_at: clock_in1.clocked_in_at, 
        clocked_out_at: clock_in1.clocked_in_at + 1.hour)

      expect(sleep_record).to be_valid
    end
  end
end