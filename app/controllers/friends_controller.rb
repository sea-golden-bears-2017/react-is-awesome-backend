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
    friend = User.find(destroy_friend_params)
    current_user.friends.delete(friend)
    render json: { status: "destroyed" }
  end

  private
  def create_friend_params
    params.require(:friend).permit(:id, :name).tap do |friend_params|
      if friend_params[:id]
        require_integer(friend_params[:id])
      else
        friend_params.require(:name)
      end
    end
  end

  def require_integer(id)
    begin
      Integer(id)
    rescue ArgumentError
      throw Exceptions::InvalidData(message: "id must be a valid number")
    end
  end

  def destroy_friend_params
    params.require(:id).tap do
      require_integer(params[:id])
    end
  end

  def get_friend_to_add
    friend_params = create_friend_params
    if friend_params[:id]
      User.find(friend_params[:id].to_i)
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
