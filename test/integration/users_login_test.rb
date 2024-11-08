require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # 1. Visit the login path.
  # 2. Verify that the new sessions form renders properly.
  # 3. Post to the sessions path with an invalid params hash.
  # 4. Verify that the new sessions form returns the right status code and gets re-rendered.
  # 5. Verify that a flash message appears.
  # 6. Visit another page (such as the Home page).
  # 7. Verify that the flash message doesn’t appear on the new page.

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
