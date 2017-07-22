require 'rails_helper'
require 'faker'
describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_params) {{user: {name: Faker::Name.name, password: Faker::Internet.password}}}
  describe '#create' do
    it 'saves a user to the database' do
      expect{post :create, params: user_params}.to change{User.count}.by(1)
    end
    it 'responds with a json blob containing the name of newly created user' do
      post :create, params: user_params
      expect(response.body).to include(user_params[:user][:name].downcase)
    end

    it 'returns a 400 if required fields are missing' do
      post :create, params: { user: { name: Faker::Name.name } }
      expect(response.status).to be(400)
    end

    it 'returns a ParameterMissing when fields are missing' do
      post :create, params: { user: { name: Faker::Name.name } }
      expect(JSON.parse(response.body)["type"]).to eq('ParameterMissing')
    end

    it 'returns a 400 status if the user already exists' do
      User.create(user_params[:user])
      post :create, params: user_params
      expect(response.status).to be(400)
    end

    it 'returns a UserExists if the user already exists' do
      User.create(user_params[:user])
      post :create, params: user_params
      expect(JSON.parse(response.body)["type"]).to eq('UserExists')
    end
  end
  describe '#update' do
    let(:password) { Faker::Internet.password }
    let(:token) { Authorization.encode_token(user) }
    let(:params) { {id: user.id, user: { password: password }, token: token } }

    it 'updates a password in the database' do
      put :update, params: params
      user.reload
      expect(user.authenticate(password)).not_to be_nil
    end

    it 'responds with a json blob containing the newly updated user info' do
      put :update, params: params
      expect(response.body).to include({
        id: user.id,
        name: user.name,
      }.to_json)
    end

    it 'returns a 403 status code if trying to update without having the password' do
      params.delete(:token)
      put :update, params: params
      expect(response.status).to be(403)
    end
  end
end
