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

  context 'for a specific user' do
    let(:user) { FactoryGirl.create :user }

    context 'when logged in as that user' do
      before (:each) { session[:user_id] = user.id }

      describe 'BooksController#index' do
        before (:each) { user.books << book }
        it 'responds with a 200 status code when viewing the users books' do
          get :index, params: {user_id: user.id}
          expect(response.status).to be(200)
        end

        it 'responds with a json array of the users books' do
          get :index, params: {user_id: user.id}
          expect(response.body).to include(book.to_json)
        end
      end

      describe 'BooksController#update' do
        it 'responds with a 200 status code when adding a book to a user' do
          put :update, params: { user_id: user.id, id: book.id }
          expect(response.status).to be(200)
        end

        it 'updates the users books' do
          put :update, params: { user_id: user.id, id: book.id }
          expect(user.books).to include(book)
        end

        it 'returns the users books' do
          put :update, params: { user_id: user.id, id: book.id }
          expect(response.body).to eq (user.books.to_json)
        end

        it 'returns a 404 status code when the book id is invalid' do
          put :update, params: { user_id: user.id, id: 4771717 }
          expect(response.status).to be(404)
        end

        it 'returns a useful error message when the book id is invalid' do
            put :update, params: { user_id: user.id, id: 4771717 }
            expect(response.body).to eq({
              error: "Couldn't find Book with 'id'=4771717",
            }.to_json)
        end
      end

      describe 'BooksController#destroy' do
        before(:each) { user.books << book }

        it 'returns a 200 status when removing an association' do
          put :destroy, params: { user_id: user.id, id: book.id }
          expect(response.status).to be(200)
        end

        it 'removes the book from the users collection' do
          put :destroy, params: { user_id: user.id, id: book.id }
          user.books.reload
          expect(user.books).not_to include(book)
        end

        it 'returns a 404 status when the book isnt found' do
          put :destroy, params: { user_id: user.id, id: 4771717 }
          expect(response.status).to be(404)
        end
        
        it 'returns a useful error message when the book id is invalid' do
            put :update, params: { user_id: user.id, id: 4771717 }
            expect(response.body).to eq({
              error: "Couldn't find Book with 'id'=4771717",
            }.to_json)
        end
      end
    end

    context 'when not logged in as that user' do
      describe 'BooksController#index' do
        it 'returns a 403 status code' do
          get :index, params: {user_id: user.id}
          expect(response.status).to be(403)
        end
      end

      describe 'BooksController#update' do
        it 'returns a 403 status code' do
          put :update, params: {user_id: user.id, id: book.id}
          expect(response.status).to be(403)
        end
      end

      describe 'BooksController#destroy' do
        it 'returns a 403 status code' do
          put :destroy, params: {user_id: user.id, id: book.id}
          expect(response.status).to be(403)
        end
      end
    end
  end

  describe '#search' do
    context 'with valid parameters' do
      it 'responds with json containing books with the specified genre' do
        get :search, params: {term: book.genre}
        expect(response.body).to include(book.to_json)
      end
      it 'responds with a 200' do
        get :search, params: {term: book.genre}
        expect(response.status).to eq(200)
      end
    end
    context 'with invalid parameters'do
      it 'responds with a 404' do
        get :search, params: {term: 'garbagegarbage'}
        expect(response.status).to eq(404)
      end
      it 'responds with an error message as json' do
        get :search, params: {term: 'garbagegarbage'}
        expect(response.body).to include("Books with the genre of garbagegarbage not found")
      end
    end
  end
end
