class UnauthorizedError < StandardError
end

class ApplicationController < ActionController::API
  def authorize!(*args)
    if !authorize(*args)
      raise UnauthorizedError
    end
  end

  def authorize(admin: false)
    valid_user = params[:user_id] == session[:user_id] && current_user
    if valid_user
      valid_permissions = !admin || current_user.is_admin?
    end
    valid_user && valid_permissions
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  rescue_from UnauthorizedError, with: :unauthorized_error

  private
  def unauthorized_error
    error = 'Unauthorized access. Please log in and try again'
    render json: {error: error }, status: 403
  end
end
