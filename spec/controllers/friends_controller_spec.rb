require 'rails_helper'

describe FriendsController do
  let(:user) { FactoryGirl.create :user }
  let(:friend) { FactoryGirl.create :user }
  before(:each) { user.friends << friend }

  context 'when logged in as the user' do
    let (:token) { Authorization.encode_token(user) }

    describe 'FriendsController#index' do
      it 'returns a 200 status code when viewing your own friends page' do
        get :index, params: { user_id: user.id, token: token }
        expect(response.status).to be(200)
      end

      it 'returns a json array of the users friends' do
        get :index, params: { user_id: user.id, token: token }
        expect(response.body).to include({
          id: friend.id,
          name: friend.name,
        }.to_json)
      end

      it "returns a 403 when trying to view the friend user's index" do
        get :index, params: { user_id: friend.id, token: token }
        expect(response.status).to be(403)
      end
    end

    describe 'FriendsController#create' do
      it 'returns a 201 status code when the friend already exists' do
        get :create, params: { user_id: user.id, friend: { id: friend.id }, token: token }
        expect(response.status).to be(201)
      end
    end

    describe 'FriendsController#destroy' do
      it 'returns a 200 status code when removing a friend' do
        delete :destroy, params: { user_id: user.id, id: friend.id, token: token }
        expect(response.status).to be(200)
      end

      it 'removes the friend relationship from the database' do
        delete :destroy, params: { user_id: user.id, id: friend.id, token: token }
        user.friends.reload
        expect(user.friends).not_to include(friend)
      end

      it 'returns a 404 status code if the friend id is invalid' do

        delete :destroy, params: { user_id: user.id, id: 841733, token: token }
        expect(response.status).to be(404)
      end
    end
  end

  context 'when logged in as the friend' do
    let (:token) { Authorization.encode_token(friend) }

    describe 'FriendsController#index' do
      it 'returns a 200 status code when trying to view the users friends' do
        get :index, params: { user_id: user.id, token: token }
        expect(response.status).to be(200)
      end
    end

    describe 'FriendsController#create' do
      it 'returns a 403 when trying to add a friend to user' do
        get :create, params: {user_id: user.id, friend: { id: friend.id }, token: token }
        expect(response.status).to be(403)
      end

      it 'returns a 201 status code when adding a friend by id' do
        get :create, params: {user_id: friend.id, friend: { id: user.id }, token: token }
        expect(response.status).to be(201)
      end

      it 'returns a 201 when adding a friend by name' do
        get :create, params: {user_id: friend.id, friend: { name: user.name }, token: token }
        expect(response.status).to be(201)
      end

      it 'adds the user to the friends list' do
        get :create, params: {user_id: friend.id, friend: { id: user.id }, token: token }
        friend.friends.reload
        expect(friend.has_friend?(user.id)).to be(true)
      end

      it 'returns a list of the current friends on success' do
        get :create, params: {user_id: friend.id, friend: { id: user.id }, token: token }
        expect(response.body).to include({
          id: user.id,
          name: user.name,
        }.to_json)
      end

      it 'returns a 404 status code if the user id is invalid' do
        get :create, params: {user_id: friend.id, friend: { id: 372642 }, token: token }
        expect(response.status).to be(404)
      end

      it 'returns a 400 if trying to friend oneself' do
        get :create, params: {user_id: friend.id, friend: { id: friend.id }, token: token }
        expect(response.status).to be(400)
      end
    end

    describe 'FriendsController#destroy' do
      it 'returns a 403 when trying to destroy a friend to user' do
        get :destroy, params: {user_id: user.id, id: friend.id, token: token }
        expect(response.status).to be(403)
      end
    end
  end
end
