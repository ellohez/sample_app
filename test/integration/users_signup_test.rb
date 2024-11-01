# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid sign up information' do
    # Not necessary but included for clarity
    # Also checks form renders without errors
    get signup_path
    # Asserts that the numeric result of evaluating the expression User.count
    # is the same before and after invoking the passed in block
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    # test correct status is returned
    assert_response :unprocessable_entity
    assert_template 'users/new'
    # find div with id 'error_explanation'
    assert_select 'div#error_explanation'
    # find a form field with the class 'field_with_errors'
    # this class is auto added by Rails to any fields with errors
    assert_select 'div.field_with_errors'
  end

  # This test proves that Users routes, the Users show action and show.html.erb view work correctly
  test 'valid signup information' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    # Arranges to follow the redirect after submission after posting to users path
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
