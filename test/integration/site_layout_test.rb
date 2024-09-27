# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout_links' do
    get root_path
    # Asserts that the request was rendered with the appropriate template file or partials.
    assert_template 'static_pages/home'
    # An assertion that selects elements and makes one or more equality tests.
    # https://api.rubyonrails.org/v4.1/classes/ActionDispatch/Assertions/SelectorAssertions.html
    # Rails auto inserts the value of 'root_path' in place of ? below (escaping special chars if necessary)
    # Therefore, the following checks for the presence of 2 x '<a href="/">' (for logo and 'Home')
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    get contact_path
    # This is a brittle test as any typo in base title won't be caught by the test suite
    # so ApplicationHelperTest tests the base title
    assert_select 'title', full_title('Contact')
  end
end
