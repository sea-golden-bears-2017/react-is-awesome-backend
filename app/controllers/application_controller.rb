class ApplicationController < ActionController::API
  rescue_from Authorization::UnauthorizedError, with: :unauthorized_error

  private
  def unauthorized_error
    error = 'Unauthorized access. Please log in and try again'
    render json: {error: error }, status: 403
  end
end
