class ApplicationController < ActionController::API
  include ActiveModel::ForbiddenAttributesProtection

  rescue_from StandardError do |exception|
    api_exception = Exceptions.convert_to_api_error(exception)
    render json: api_exception, status: api_exception.status
  end
end
