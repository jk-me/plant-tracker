require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user_one = users(:one)
    @user_two = users(:two)
  end

  test "should validate user one email address" do
    assert_equal "one@example.com", @user_one.email_address
  end

  test "should validate user two email address" do
    assert_equal "two@example.com", @user_two.email_address
  end

  test "should authenticate user with correct password" do
    assert @user_one.authenticate("password")
  end

  test "should not authenticate user with incorrect password" do
    refute @user_one.authenticate("wrongpassword")
  end
end
