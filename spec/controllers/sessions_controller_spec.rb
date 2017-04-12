require 'rails_helper'
require 'json'

describe SessionsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  describe '#create' do
    context 'on valid params' do
      before(:each) do
        post :create, params: {name: user.name, password: user.password }
      end
      it 'sets the session id to the id of the user' do
        expect(session[:id]).to eq(user.id)
      end
      it 'responds with the newly set session id' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["session_id"]).to eq(user.id)
      end
    end
    context 'on invalid params' do
      before(:each) do
        post :create, params: {name: user.name, password: 'ham' }
      end
      it 'responds with a status of 403' do
        expect(response).to have_http_status(403)
      end
      it 'responds with an error message stating credentials are invalid' do
        expect(response.body).to include("Invalid user name or password.")
      end
    end
    it 'when a user is logged in it responds with an error message stating user is currently logged in' do
      session[:id] = user.id
      post :create, params: {name: user.name, password: user.password }
      expect(response.body).to include("You are already logged in. Your session id is set to #{session[:id]}")
    end
  end
  describe '#destroy' do
    before(:each) do
      delete :destroy, params: {id: user.id}
    end
    it 'clears the user id from the session' do
      expect(session[:id]).to be_nil
    end
    it 'responds with a message stating that the user has been logged out' do
      expect(response.body).to include("You have been successfully logged out")
    end
  end
end
