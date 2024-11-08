module SessionsHelper
  # Logs in the given user
  def log_in(user)
    # Temporary cookies created using the session method are automatically encrypted
    session[:user_id] = user.id
  end
end
