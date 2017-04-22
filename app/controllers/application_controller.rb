class ApplicationController < ActionController::API
  include ActiveModel::ForbiddenAttributesProtection
  rescue_from Authorization::UnauthorizedError, with: :unauthorized_error

  rescue_from ActionController::ParameterMissing do |exception|
    render json: {type: 'ParameterMissing', message: exception.message }, status: 400
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {type: 'NotFound', message: exception.message }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: {type: 'InvalidData', message: exception.message }, status: 400
  end

  private
  def unauthorized_error
    error = 'Unauthorized access. Please log in and try again'
    render json: {type: 'Unauthorized', error: error }, status: 403
  end
end
