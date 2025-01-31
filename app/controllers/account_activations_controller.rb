# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # If the user exists and is not already activated, and the activation token is valid
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Activate the user and update the activation time
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
