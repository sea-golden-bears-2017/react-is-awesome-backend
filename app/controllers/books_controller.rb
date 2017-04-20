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
    render json: Book.find(params[:id])
  end

  def search
    books = Book.where(genre: params[:term])
    if books.any?
      render json: books, status: 200
    else
      render json: {error: "Books with the genre of #{params[:term]} not found"}, status: 404
    end
  end
end
