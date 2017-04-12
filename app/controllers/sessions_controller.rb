class SessionsController < ApplicationController
  def create
    user = User.find_by(name: session_params[:name])
    if user.authenticate(session_params[:password])
      session[:id] = user.id
    else
      render json: {error: "Invalid user name or password."}.to_json, status: 403
    end
  end
  def destroy
  end

  private

  def session_params
    params.permit(:name, :password)
  end
end
