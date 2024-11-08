# frozen_string_literal: true

# Class description goes here
class ApplicationController < ActionController::Base
  include SessionsHelper
  def hello
    render html: 'Hello, world!'
  end
end
