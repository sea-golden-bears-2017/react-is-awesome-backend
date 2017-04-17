class BooksController < ApplicationController
  def index
    if params[:user_id]
      if session[:user_id] == params[:user_id]
        user = User.find(params[:user_id])
        render json: user.books
      else
        render json: {error: 'Unauthorized access. Please log in and try again.'}, status: 403
      end
    else
      render json: Book.all
    end
  end

  def show
    render json: Book.find(params[:id])
  end
end
