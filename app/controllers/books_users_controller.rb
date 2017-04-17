class BooksUsersController < ApplicationController
  def index
    @books = Book.where(user_id: params[:user_id])
    render json: @books
  end
end
