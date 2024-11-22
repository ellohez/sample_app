# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # To allow us to test for the right title
    include ApplicationHelper

    # Add more helper methods to be used by all tests here...

    # Returns true if a test user is logged in.
    def is_logged_in?
      !session[:user_id].nil?
    end

    #  Inside controller tests, we can manipulate the session method directly,
    # assigning user.id to the :user_id key
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Because it’s located inside the ActionDispatch::IntegrationTest class,
    # this is the version of log_in_as that will be called inside integration tests
    # Inside integration tests, we can’t manipulate session directly, but we can post to the sessions path
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email,
                                            password:,
                                            remember_me: } }
    end
  end
end
