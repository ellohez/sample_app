require "test_helper"

# The auto created version of a test will just add a simple test for each action
# in the controller.
# Each test simply 'gets' a URL and uses an assertion
# to verify that the result is a success.
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    # The :success response is and abstract representation of the
    # HTTP status code - 200 OK
    assert_response :success
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
  end
end
