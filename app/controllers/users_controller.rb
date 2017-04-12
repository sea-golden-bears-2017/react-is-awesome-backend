class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    user.save
    render json: {name: user.name}
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
