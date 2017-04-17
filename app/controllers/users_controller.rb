class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.save
    render json: {name: user.name}
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
