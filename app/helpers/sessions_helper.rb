module SessionsHelper
  # Logs in the given user
  def log_in(user)
    # Temporary cookies created using the session method are automatically encrypted
    session[:user_id] = user.id
    # Guard against session replay attacks.
    # See https://bit.ly/33UvK0w for more.
    session[:session_token] = user.session_token
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    # Encrypts the user id and stores it in the browser's persistent cookies
    # 'permanent' sets the expiry to 20.years.from.now.utc
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns user corresponding to the remember token cookie
  # disabled Rubocop as seems to think this is a view!
  # noinspection RailsChecklist05
  def current_user
    # Confusing but simplified syntax - assigns then tests for truthiness
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      @current_user = user if user && session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      # Safe version of user && user.authenticated?...
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Forgets a permanent/persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
