require 'rails_helper'

RSpec.describe ClockIn, type: :model do
  let!(:user1) { create(:user) }
  
  it 'succeed' do
    clock_in = ClockIn.new(user_id: user1.id, clocked_in_at: Time.now, is_clocked_out: false)
    expect(clock_in).to be_valid
  end
end