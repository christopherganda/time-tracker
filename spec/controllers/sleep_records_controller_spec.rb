require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  now = Time.now
  describe '#get' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
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
    
    context 'when actor_id does not exist' do
      it 'returns not found error' do
        post :get, params: { actor: nil }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to include('Actor does not exist')
      end
    end

    context 'success' do
      it 'returns sleep record' do
        get :get, params: { actor: user.id }
        expect(response).to have_http_status(:ok)

        json_resp = JSON.parse(response.body)
        expect(json_resp['message']).to eq(I18n.t('success.messages.success'))
        expect(json_resp['data'].size).to eq(1)

        record = json_resp['data'].first
        expect(record).to include('followee_id', 'sleep_length', 'clocked_in_at', 'clocked_out_at')
        expect(record['followee_id']).to eq(followed_user.id)
        expect(record['clocked_in_at']).to eq(recent_sleep_record.clocked_in_at.strftime('%B %d, %Y at %I:%M %p'))
        expect(record['clocked_out_at']).to eq(recent_sleep_record.clocked_out_at.strftime('%B %d, %Y at %I:%M %p'))
        expected_sleep_length = (recent_sleep_record.clocked_out_at - recent_sleep_record.clocked_in_at).to_i
        expect(record['sleep_length']).to eq(format_sleep_length(expected_sleep_length))
      end
    end
  end

  def format_sleep_length(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60
    "#{hours} hours, #{minutes} minutes, #{remaining_seconds} seconds"
  end
end
