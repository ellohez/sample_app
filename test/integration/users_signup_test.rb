# frozen_string_literal: true

require 'test_helper'

class UsersSignup < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
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

  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { name: 'Example User',
                                       email: 'user@example.com',
                                       password: 'password',
                                       password_confirmation: 'password' } }
    @user = assigns(:user)
  end

  test 'should not be activated' do
    assert_not @user.activated?
  end

  test 'should not be able to log in before activation' do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test 'should not be able to log in with invalid activation token' do
    get edit_account_activation_path('invalid token', email: @user.email)
    assert_not is_logged_in?
  end

  test 'should not be able to log in with invalid email' do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test 'should log in successfully with valid activation token and email' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
