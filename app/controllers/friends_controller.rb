class FriendsController < ApplicationController
  include Authorization
  before_action :authorize_if_needed

  def index
    render json: convert_friends_for_display(endpoint_user.friends)
  end

  def create
    require_self
    if current_user.id == friend_id
      render json: { error: "Cannot friend oneself" }, status: 400
    else
      friend = User.find_by(id: friend_id)
      if friend
        current_user.friends << friend
        render json: convert_friends_for_display(current_user.friends), status: :created
      else
        render json: { error: "User id #{friend_id} not found" }, status: 404
      end
    end
  end

  def destroy
    require_self
    friend = User.find_by(id: friend_id)
    if friend
      current_user.friends.delete(friend)
      render json: { status: "destroyed" }
    else
      render json: { error: "Friend not found" }, status: 404
    end
  end

  private
  def friend_id
    params.require(:id).to_i
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
