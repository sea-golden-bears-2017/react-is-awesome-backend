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
end
