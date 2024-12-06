# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:kermit)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo.invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_equal edit_user_url(@user), session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert session[:forwarding_url].nil?

    # Submit valid user information
    get edit_user_path(@user)
    name = 'Ford Prefect'
    email = 'ford@hitchikers.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    # Check for nonempty flash message
    assert_not flash.empty?
    # Check for successful redirect to profile page
    assert_redirected_to @user
    # Verify user's information correctly changed in DB
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
