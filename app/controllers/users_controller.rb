class UsersController < ApplicationController
  include Authorization

  def create
    user = User.new(user_params)
    user.save
    render json: {
      id: user.id,
      name: user.name,
    }
  end

  def update
    require_self
    user = User.find(params[:id])
    user.update_attributes(user_params)
    render json: {
      id: user.id,
      name: user.name
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
