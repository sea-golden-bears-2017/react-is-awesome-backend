module Authorization
  class UnauthorizedError < StandardError
  end

  def authorize!(*args)
    if !authorize(*args)
      raise Authorization::UnauthorizedError
    end
  end

  def authorize(admin: false)
    valid_user = current_user && !params[:user_id] || params[:user_id] == session[:user_id]
    if valid_user
      valid_permissions = !admin || current_user.is_admin?
    end
    valid_user && valid_permissions
  end

  def require_login
    authorize!
  end

  def require_admin
    authorize!(admin: true)
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
end
