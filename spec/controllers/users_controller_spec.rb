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
  describe '#show' do
    it 'responds with a json blob containing specific user info' do
      get :show, params: {id: user.id}
      expect(response.body).to include(user.to_json)
    end
  end
end
