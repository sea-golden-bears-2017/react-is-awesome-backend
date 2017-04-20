class ApplicationController < ActionController::API
  include ActiveModel::ForbiddenAttributesProtection
  rescue_from Authorization::UnauthorizedError, with: :unauthorized_error
  rescue_from ActionController::ParameterMissing do |exception|
    error = "Missing required parameter #{exception.param}"
    render json: {error: error }, status: 400
  end

  private
  def unauthorized_error
    error = 'Unauthorized access. Please log in and try again'
    render json: {error: error }, status: 403
  end
end
