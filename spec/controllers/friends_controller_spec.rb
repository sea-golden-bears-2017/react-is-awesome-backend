require 'rails_helper'

describe FriendsController do
  let(:user) { FactoryGirl.create :user }
  let(:friend) { FactoryGirl.create :user }
  before(:each) { user.friends << friend }

  context 'when logged in as the user' do
    before(:each) { session[:user_id] = user.id.to_s }

    describe 'FoodsController#index' do
      it 'returns a 200 status code when viewing your own friends page' do
        get :index, params: { user_id: user.id }
        expect(response.status).to be(200)
      end

      it 'returns a json array of the users friends' do
        get :index, params: { user_id: user.id }
        expect(response.body).to include(friend.to_json)
      end

      it "returns a 403 when trying to view the friend user's index" do
        get :index, params: { user_id: friend.id }
        expect(response.status).to be(403)
      end
    end
  end

  context 'when logged in as the friend' do
    before(:each) { session[:user_id] = friend.id.to_s }

    describe 'FoodsController#index' do
      it 'returns a 200 status code when trying to view the users friends' do
        get :index, params: { user_id: user.id }
        expect(response.status).to be(200)
      end
    end

    describe 'FoodsController#create' do
      it 'returns a 403 when trying to add a friend to user' do
        get :create, params: {user_id: user.id, id: friend.id }
        expect(response.status).to be(403)
      end

      it 'returns a 201 status code when adding user as a friend to friend' do
        get :create, params: {user_id: friend.id, id: user.id }
        expect(response.status).to be(201)
      end

      it 'adds the user to the friends list' do
        get :create, params: {user_id: friend.id, id: user.id }
        friend.friends.reload
        expect(friend.has_friend?(user.id)).to be(true)
      end

      it 'returns a list of the current friends on success' do
        get :create, params: {user_id: friend.id, id: user.id }
        expect(response.body).to include(user.to_json)
      end

      it 'returns a 404 status code if the user id is invalid' do
        get :create, params: {user_id: friend.id, id: 372642 }
        expect(response.status).to be(404)
      end

      it 'returns a 400 if trying to friend oneself' do
        get :create, params: {user_id: friend.id, id: friend.id }
        expect(response.status).to be(400)
      end
    end

    describe 'FoodsController#destroy' do
      it 'returns a 403 when trying to destroy a friend to user' do
        get :destroy, params: {user_id: user.id, id: friend.id }
        expect(response.status).to be(403)
      end
    end
  end
end
