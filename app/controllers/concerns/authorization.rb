module Authorization
  class UnauthorizedError < StandardError
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def user_matches_params?
    current_user && params[:user_id] == session[:user_id]
  end

  def require_logged_in
    if !current_user
      raise Authorization::UnauthorizedError
    end
  end

  def authorize_if_needed
    if params[:user_id] && !user_matches_params?
      raise Authorization::UnauthorizedError
    end
  end

  def authorize
    require_logged_in && user_matches_params?
  end

  def authorize_admin
    require_logged_in
    if !current_user.is_admin?
      raise Authorization::UnauthorizedError
    end
  end
end
