class FriendsController < ApplicationController
  include Authorization
  before_action :authorize_if_needed

  def index
    render json: convert_friends_for_display(endpoint_user.friends)
  end

  def create
    require_self
    friend = get_friend_to_add
    if current_user == friend
      raise Exceptions::InvalidDataError.new(message: "Cannot friend oneself")
    end

    current_user.friends << friend
    render json: convert_friends_for_display(current_user.friends), status: :created
  end

  def destroy
    require_self
    friend = User.find(params[:id])
    current_user.friends.delete(friend)
    render json: { status: "destroyed" }
  end

  private
  def create_friend_params
    params.require(:friend).permit(:id, :name).tap do |friend_params|
      if !friend_params[:id]
        friend_params.require(:name)
      end
    end
  end

  def get_friend_to_add
    friend_params = create_friend_params
    if friend_params[:id]
      User.find(friend_params[:id])
    else
      User.find_by!(name: friend_params[:name])
    end
  end

  def convert_friends_for_display(friends)
    endpoint_user.friends.map do |friend|
      {
        id: friend.id,
        name: friend.name,
      }
    end
  end
end
