# frozen_string_literal: true

# Class description goes here
class ApplicationController < ActionController::Base
  include SessionsHelper
  def hello
    render html: 'Hello, world!'
  end

  private

  # Before filters
  # Confirms a logged-in user
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in'
    redirect_to login_url, status: :see_other
  end
end
