class UnauthorizedError < StandardError
end

class ApplicationController < ActionController::API
  def authorize!
    if !authorize
      raise UnauthorizedError
    end
  end

  def authorize
    return params[:user_id] == session[:user_id] && current_user
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  rescue_from UnauthorizedError do |exception|
    error = 'Unauthorized access. Please log in and try again'
    render json: {error: error }, status: 403
  end
end
