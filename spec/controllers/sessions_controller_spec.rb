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
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["token"]).to eq(Authorization.encode_token(user))
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
  end
end
