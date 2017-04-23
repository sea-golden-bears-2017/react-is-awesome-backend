class ApplicationController < ActionController::API
  include ActiveModel::ForbiddenAttributesProtection

  rescue_from ActionController::ParameterMissing do |exception|
    render json: {type: 'ParameterMissing', message: exception.message }, status: 400
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {type: 'NotFound', message: exception.message }, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render json: {type: 'InvalidData', message: exception.message }, status: 400
  end

  rescue_from Exceptions::ApiError do |exception|
    render json: exception, status: exception.status
  end
end
