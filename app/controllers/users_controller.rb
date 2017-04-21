class UsersController < ApplicationController
  include Authorization
  
  def create
    user = User.new(user_params)
    user.save
    render json: {name: user.name}
  end

  def update
    require_self
    user = User.find(params[:id])
    user.update_attributes(user_params)
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
