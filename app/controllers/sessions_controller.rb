# frozen_string_literal: true

class SessionsController < ApplicationController
  # Remember - there is no related Active Record model for session (unlike for User)
  def new; end

  # @return [nil]
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    # Safer version of if user && user.authenticate...
    # This Ruby feature allows us to condense the common pattern of obj && obj.method into obj&.method
    if @user&.authenticate(params[:session][:password])
      # Pull out the URL here before calling reset_session which will delete it
      forwarding_url = session[:forwarding_url]
      # resetting helps prevent a session 'fixation' attack
      # also removes the forwarding URL so that subsequent login attempts do not get redirected
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # Log the user in and redirect to the user's show page
      log_in @user
      # Rails auto converts this to route - user_url(user)
      redirect_to forwarding_url || @user
    else
      # Create an error message (.now makes it disappear as soon as there is an additional request)
      # - otherwise this would remain on screen even if the user navigates away
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      # This will be necessary when we add Turbo
      render 'new', status: :unprocessable_entity
    end
  end

  # TODO: Should this call reset_session? & Can the turbo-method be removed from _header.html.erb?
  def destroy
    log_out if logged_in?
    # Using Turbo, this status code (corresponding to the HTTP status code 303 See Other)
    # is necessary to ensure the correct behavior when redirecting after a DELETE request
    # https://api.rubyonrails.org/classes/ActionController/Redirecting.html
    redirect_to root_url, status: :see_other
  end
end
