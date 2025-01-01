require 'rails_helper'

RSpec.describe ClockIn, type: :model do
  let!(:user1) { User.create!(name: "test1") }
  
  context 'validations' do
    it 'succeed' do
      clock_in = ClockIn.new(user_id: user1.id, clocked_in_at: Time.now.getutc, is_clocked_out: false)
      expect(clock_in).to be_valid
    end
  end
end