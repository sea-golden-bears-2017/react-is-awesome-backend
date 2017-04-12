require 'rails_helper'

describe SessionsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  describe '#create' do
    it 'sets the session id to the id of the user' do
      post :create, params: {name: user.name, password: user.password }
      expect(session[:id]).to eq(user.id)
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
end
