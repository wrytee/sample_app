require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {  session: {  email:      @user.email,
                                            password:   "invalid" } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    # Visit the login path.
    get login_path
    
    # Post valid information to the session path.
    post login_path, params: { session: { email:    @user.email,
                                          password:  'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    
    # Verfify that the login link disappears.
    assert_select "a[href=?]", login_path, count: 0
    
    # Verfiy that a logout link appears.
    assert_select "a[href=?]", logout_path
    
    # Verfiy that a profile link appears.
    assert_select "a[href=?]", user_path(@user)
    
    # Log the user out.
    delete logout_path
    
    # Confirm the user is not logged in.
    assert_not is_logged_in?
    
    # Verify the user was returned to the home page.
    assert_redirected_to root_url
    follow_redirect!
    
    # Verify a log-in link appears.
    assert_select "a[href=?]", login_path
    
    # Verify the logout link does not appear.
    assert_select "a[href=?]", logout_path,       count: 0
    
    # Verify that the users link does not appear.
    assert_select "a[href=?]", user_path(@user),  count: 0
  end

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
