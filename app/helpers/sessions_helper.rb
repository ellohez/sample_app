module SessionsHelper
  # Logs in the given user
  def log_in(user)
    # Temporary cookies created using the session method are automatically encrypted
    session[:user_id] = user.id
  end

  # Returns the currently logged-in user, if any - disabled Rubocop and seems to think this is a view!
  # noinspection RailsChecklist05
  def current_user
    if session[:user_id]
      @current_user = @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    reset_session
    current_user = nil
  end
end
