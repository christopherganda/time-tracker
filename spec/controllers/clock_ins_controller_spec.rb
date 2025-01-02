require 'rails_helper'

RSpec.describe ClockInsController, type: :controller do
  describe 'post #upsert' do
    let!(:user1) { User.create(name: 'test1') }
    context 'when user does not exist' do
      it 'trigger error' do
        post :upsert, params: { actor: nil }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to include('Actor does not exist')
      end
    end

    context 'when last_unused_clock_in not exist' do
      it 'creates new clock in' do
        expect {
          post :upsert, params: { actor: user1.id }
        }.to change(ClockIn, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('success.messages.clock_in_success'))
      end
    end

    context 'when last_unused_clock_in exist' do
      before do
        ClockIn.create(
          user_id: user1.id,
          clocked_in_at: Time.now
        )
      end
      it 'creates new sleep record and update previous clock in to true' do
        expect {
          post :upsert, params: { actor: user1.id }
        }.to change(SleepRecord, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('success.messages.clock_out_success'))
      end
    end

    context 'when an ActiveRecord error occurs' do
      it 'handles the error properly' do
        allow(ClockIn).to receive(:create).and_raise(ActiveRecord::ActiveRecordError.new('db error'))

        post :upsert, params: { actor: user1.id }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('db error')
      end
    end
  end
end