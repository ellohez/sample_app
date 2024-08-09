require "test_helper"

# The auto created version of a test will just add a simple test for each action
# in the controller.
# Each test simply 'gets' a URL and uses an assertion
# to verify that the result is a success.
class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get static_pages_home_url
    # The :success response is and abstract representation of the
    # HTTP status code - 200 OK
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
end
