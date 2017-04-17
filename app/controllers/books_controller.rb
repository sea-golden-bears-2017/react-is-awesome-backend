class BooksController < ApplicationController
  def index
    if params[:user_id]
      authorize!
      render json: current_user.books
    else
      render json: Book.all
    end
  end

  def show
    render json: Book.find(params[:id])
  end
end
