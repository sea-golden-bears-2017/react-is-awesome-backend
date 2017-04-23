class SessionsController < ApplicationController
  def create
    raise Exceptions::AlreadyLoggedInError if session[:user_id]
    user = User.find_by(name: session_params[:name].downcase)
    raise Exceptions::UnauthorizedError if !user || !user.authenticate(session_params[:password])

    session[:user_id] = user.id
    render json: {user_id: user.id}
  end

  def destroy
    session.clear
    render json: {message: "You have been successfully logged out"}
  end

  private

  def session_params
    params.require(:user).permit(:name, :password).tap do |session_params|
      session_params.require([:name, :password])
    end
  end
end
