require 'rails_helper'

RSpec.describe UserFollowsController, type: :controller do
  let!(:user1) { User.create!(name: "test1") }
  let!(:user2) { User.create!(name: "test2") }

  describe "POST #create" do
    context "when actor_id does not exist" do
      it "returns not found error" do
        post :create, params: { actor: 100, followee_id: 100 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Follower/actor does not exist")
      end
    end

    context "when the followee does not exist" do
      it "returns not found error" do
        post :create, params: { actor: user1.id, followee_id: 100 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Followee does not exist")
      end
    end

    context "success" do
      it "creates record to UserFollow" do
        post :create, params: { actor: user1.id, followee_id: user2.id }
        expect(response).to have_http_status(:ok)
        expect(UserFollow.exists?(follower_id: user1.id, followee_id: user2.id)).to be_truthy
      end
    end

    context "when the user tries to follow themselves" do
      it "returns internal server error" do
        post :create, params: { actor: user1.id, followee_id: user1.id }
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)["error"]).to eq(["Follower cannot be the same as Followee"])
      end
    end
  end

  describe "DELETE #destroy" do
    context "success" do
      before do
        UserFollow.create(follower_id: user1.id, followee_id: user2.id)
      end

      it "delete record from UserFollow" do
        delete :destroy, params: { actor: user1.id, followee_id: user2.id }
        expect(response).to have_http_status(:ok)
        expect(UserFollow.exists?(follower_id: user1.id, followee_id: user2.id)).to be_falsey
      end
    end

    context "record does not exist" do
      it "return relationship does not exist" do
        delete :destroy, params: { actor: user1.id, followee_id: user2.id }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Following relationship does not exist")
      end
    end
  end
end