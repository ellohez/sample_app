# frozen_string_literal: true

require 'test_helper'

class UsersIndex < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:kermit)
    @non_admin = users(:gonzo)
  end

  class UsersIndexAdmin < UsersIndex
    def setup
      super
      log_in_as(@admin)
      get users_path
    end
  end

  class UsersIndexAdminTest < UsersIndexAdmin
    test 'should render the index page' do
      assert_template 'users/index'
    end

    test 'should paginate users' do
      assert_select 'div.pagination'
    end

    test 'should have delete links' do
      first_page_of_users = User.where(activated: true).paginate(page: 1)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          # There will be a delete link for every user except the logged in one (i.e. the admin)
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
    end

    test 'should display only activated users' do
      # Deactivate the first user on the page
      # Making an inactive fixture user isn't sufficient because Rails can't
      # guarantee it would appear on the first page of users
      User.paginate(page: 1).first.toggle!(:activated)
      # Re-get /users to confirm the deactivated user is not displayed
      get users_path
      # Ensure that all the displayed users are activated
      assigns(:users).each do |user|
        assert user.activated?
      end
    end
  end
end

class UsersIndexNonAdminIndexTest < UsersIndex
  test 'should not have delete links as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
