class UsersController < ApplicationController
  include Authorization

  def create
    create_params = require_params(:name, :password)
    user = User.new(create_params)
    user.save!
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
    params.require(:user).permit(:name, :password, :is_admin?)
  end

  def require_params(*names)
    user_params.tap do |user_params|
      user_params.require(names)
    end
  end
end
