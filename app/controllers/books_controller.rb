class BooksController < ApplicationController
  include Authorization
  before_action :authorize_if_needed
  def index
    if params[:user_id]
      render json: endpoint_user.books
    else
      render json: Book.all
    end
  end

  def show
    if params[:user_id]
      raise NotImplementedError
    else
      render json: Book.find(book_id)
    end
  end

  def update
    if params[:user_id]
      book = Book.find(book_id)
      endpoint_user.books << book
      render json: endpoint_user.books
    else
      raise NotImplementedError
    end
  end

  def destroy
    if params[:user_id]
      book = Book.find(book_id)
      endpoint_user.books.delete(book)
    else
      require_admin
      book = Book.find(book_id)
      book.delete()
    end
    render json: { status: "destroyed" }
  end

  def search
    books = Book.where(genre: params[:term])
    if books.any?
      render json: books, status: 200
    else
      render json: {error: "Books with the genre of #{params[:term]} not found"}, status: 404
    end
  end

  private
  def book_id
    params.require(:id)
  end
end
