require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    # Visit the login path.
    get login_path
    
    # Verify new session form renders properly.
    assert_template 'sessions/new'
    
    # Post to the sessions path with an invalid params hash.
    post login_path, params: { session: { email: "", password: "" } }
    
    # Verify that the new sessions form is re-rendered.
    assert_template 'sessions/new'
    
    # Verify that a flash message appears on the re-rendered page.
    assert_not flash.empty?
    
    # Visit the home page.
    get root_path
    
    # Verify that the flash message doesnt appear on the new page.
    assert flash.empty?
  end
end
