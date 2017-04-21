class SessionsController < ApplicationController
  def create
    return render json: {error: "You are already logged in. Your session id is set to #{session[:user_id]}"} if session[:user_id]
    user = User.find_by(name: session_params[:name])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      render json: {user_id: user.id}
    else
      render json: {error: "Invalid user name or password."}.to_json, status: 403
    end
  end

  def destroy
    session.clear
    render json: {message: "You have been successfully logged out"}
  end

  private

  def session_params
    params.permit(:name, :password)
  end
end
