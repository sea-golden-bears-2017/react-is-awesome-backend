require 'rails_helper'

describe BooksController do
  let!(:book) { FactoryGirl.create :book }
  describe 'BooksController#index' do
    it 'renders a json blob containing books' do
      get :index
      expect(response.body).to include(book.to_json)
    end
  end
  describe 'BooksController#show' do
    it 'renders a json blob containing a book' do
      get :show, params: {id: book.id}
      expect(response.body).to eq(book.to_json)
    end
  end
  context 'passed a user_id' do
    let(:user) { FactoryGirl.create :user }
    before(:each) do
      user.books << book
    end

    it 'responds with json containing books for a specific user when a user is logged in' do
      session[:user_id] = user.id.to_s
      get :index, params: {user_id: user.id}
      expect(response.body).to include(book.to_json)
    end

    it 'responds with a status of 403 when a user is not logged in' do
      get :index, params: {user_id: user.id}
      expect(response.status).to eq(403)
    end
  end
end
