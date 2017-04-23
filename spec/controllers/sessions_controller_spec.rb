require 'rails_helper'
require 'json'

describe SessionsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  describe '#create' do
    context 'on valid params' do
      let(:params) { { user: { name: user.name, password: user.password } } }
      before(:each) do
      end
      it 'sets the session id to the id of the user' do
        post :create, params: params
        expect(session[:user_id]).to eq(user.id)
      end
      it 'responds with the newly set session id' do
        post :create, params: params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["user_id"]).to eq(user.id)
      end
    end
    context 'on invalid params' do
      let(:params) { { user: { name: user.name, password: 'ham' } } }
      it 'responds with a status of 403' do
        post :create, params: params
      end
      it 'responds with an error message stating credentials are invalid' do
        post :create, params: params
        expect(JSON.parse(response.body)["type"]).to eq("Unauthorized")
      end
    end
    it 'when a user is logged in it responds with an error message stating user is currently logged in' do
      session[:user_id] = user.id
      post :create, params: {name: user.name, password: user.password }
      expect(JSON.parse(response.body)["type"]).to eq("AlreadyLoggedIn")
    end
  end
  describe '#destroy' do
    before(:each) do
      delete :destroy, params: {id: user.id}
    end
    it 'clears the user id from the session' do
      expect(session[:user_id]).to be_nil
    end
    it 'responds with a message stating that the user has been logged out' do
      expect(response.body).to include("You have been successfully logged out")
    end
  end
end
