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
      expect(response.body).to include(user_params[:user][:name])
    end
  end
  describe '#update' do
    let(:name) { Faker::Name.name }
    before(:each) do
      session[:user_id] = user.id
    end
    it 'updates a user in the database' do
      put :update, params: {id: user.id, user: {name: name }}
      expect(user.reload.name).to eq(name)
    end
    it 'responds with a json blob containing the newly updated user info' do
      put :update, params: {id: user.id, user: {name: name }}
      expect(response.body).to include(name)
    end

    it 'returns a 403 status code if trying to update without having the password' do
      session[:user_id] = 435235
      put :update, params: {id: user.id, user: {name: name }}
      expect(response.status).to be(403)
    end
  end
end
