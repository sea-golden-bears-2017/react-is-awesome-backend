module Authorization
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def endpoint_user
    return unless params[:user_id]
    endpoint_user ||= User.find_by(id: params_id)
  end

  def require_current_user
    raise Exceptions::UnauthorizedError unless current_user
  end

  def require_self
    require_current_user
    if params[:user_id] && params_id != session[:user_id]
      raise Exceptions::UnauthorizedError
    end
  end

  def require_admin
    require_current_user
    raise Exceptions::UnauthorizedError unless current_user.is_admin?
  end

  def authorize_if_needed
    if params[:user_id]
      require_current_user
      if params_id != session[:user_id]
        raise Exceptions::UnauthorizedError unless current_user.is_friend_of?(params_id)
      end
    end
  end

  def params_id
    params[:user_id].to_i
  end
end
