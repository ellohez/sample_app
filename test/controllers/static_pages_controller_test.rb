# frozen_string_literal: true

require 'test_helper'

# The auto created version of a test will just add a simple test for each action
# in the controller.
# Each test simply 'gets' a URL and uses an assertion
# to verify that the result is a success.
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home (root)' do
    get root_path

    # The :success response is an abstract representation of the
    # HTTP status code - 200 OK
    assert_response :success
    assert_select 'title', full_title
  end

  test 'should get help' do
    get help_path
    assert_response :success
    assert_select 'title', full_title('Help')
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_select 'title', full_title('About')
  end

  test 'should get contact' do
    get contact_path
    assert_response :success
    assert_select 'title', full_title('Contact')
  end
end
