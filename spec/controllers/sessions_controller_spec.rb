require 'rails_helper'

describe SessionsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  describe '#create' do
    it 'sets the session id to the id of the user' do
      post :create, params: {name: user.name, password: user.password }
      expect(session[:id]).to eq(user.id)
    end
  end
end
