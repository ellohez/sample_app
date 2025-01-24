# frozen_string_literal: true

require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @inactive_user = users(:inactive)
    @activated_user = users(:kermit)
  end

  test 'should redirect to root if user is not activated' do
    get user_path(@inactive_user)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should show user if user is activated' do
    get user_path(@activated_user)
    assert_response :success
    assert_template 'users/show'
  end
end
