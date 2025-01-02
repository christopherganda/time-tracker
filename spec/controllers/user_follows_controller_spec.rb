require 'rails_helper'

RSpec.describe UserFollowsController, type: :controller do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  describe 'POST #create' do
    context 'when actor_id does not exist' do
      it 'returns not found error' do
        post :create, params: { actor: nil, followee_id: nil }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to include('Actor does not exist')
      end
    end

    context 'when the followee does not exist' do
      it 'returns not found error' do
        post :create, params: { actor: user1.id, followee_id: nil }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Followee does not exist')
      end
    end

    context 'success' do
      it 'creates record to UserFollow' do
        expect {
          post :create, params: { actor: user1.id, followee_id: user2.id }
        }.to change(UserFollow, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(UserFollow.exists?(follower_id: user1.id, followee_id: user2.id)).to be_truthy
      end
    end

    context 'when the user tries to follow themselves' do
      it 'returns unprocessable entity error' do
        post :create, params: { actor: user1.id, followee_id: user1.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to include('Follower cannot be the same as Followee')
      end
    end

    context 'when record not unique is triggered' do
      it 'returns conflict error' do
        allow(UserFollow).to receive(:create!).and_raise(ActiveRecord::RecordNotUnique.new("duplicate entry"))

        post :create, params: { actor: user1.id, followee_id: user1.id }

        expect(response).to have_http_status(:conflict)
        expect(response.body).to include(I18n.t('activerecord.errors.has_been_followed'))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'success' do
      before do
        UserFollow.create(follower_id: user1.id, followee_id: user2.id)
      end

      it 'delete record from UserFollow' do
        expect {
          delete :destroy, params: { actor: user1.id, followee_id: user2.id }
        }.to change(UserFollow, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(UserFollow.exists?(follower_id: user1.id, followee_id: user2.id)).to be_falsey
      end
    end

    context 'record does not exist' do
      it 'return relationship does not exist' do
        delete :destroy, params: { actor: user1.id, followee_id: user2.id }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Following relationship does not exist')
      end
    end

    context 'when error is raised' do
      before do
        UserFollow.create(follower_id: user1.id, followee_id: user2.id)
        allow_any_instance_of(UserFollow).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed.new("error"))
      end
      it 'return error' do
        delete :destroy, params: { actor: user1.id, followee_id: user2.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end