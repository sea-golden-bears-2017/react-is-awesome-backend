class FriendsController < ApplicationController
  include Authorization
  before_action :authorize_if_needed

  def index
    # TODO this returns things like the password_digest
    # and is_admin?
    render json: endpoint_user.friends
  end

  def create
    require_self
    if current_user.id == friend_id
      render json: { error: "Cannot friend oneself" }, status: 400
    else
      friend = User.find_by(id: friend_id)
      if friend
        current_user.friends << friend
        render json: current_user.friends, status: :created
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
end
