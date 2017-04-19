class BooksController < ApplicationController
  include Authorization
  before_action :require_login
  def index
    if params[:user_id]
      render json: current_user.books
    else
      render json: Book.all
    end
  end

  def show
    render json: Book.find(params[:id])
  end
end
