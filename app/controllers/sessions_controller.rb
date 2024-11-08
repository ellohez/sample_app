class SessionsController < ApplicationController
  # Remember - there is no related Active Record model for session (unlike for User)
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # Safer version of if user && user.authenticate...
    if user&.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page
      # resetting helps prevent a session 'fixation' attack
      reset_session
      log_in user
      # Rails auto converts this to route - user_url(user)
      redirect_to user
    else
      # Create an error message (.now makes it disappear as soon as there is an additional request)
      # - otherwise this would remain on screen even if the user navigates away
      flash.now[:danger] = "Invalid email/password combination" # Not quite right!
      # This will be necessary when we add Turbo
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy; end
end
