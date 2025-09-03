require "rails_helper"

RSpec.describe "Authentication", type: :system do
  before { driven_by(:rack_test) }

  let(:user_attrs) { { email_address: "user@example.com", password: "password", password_confirmation: "password" } }

  it "does not show welcome page when not logged in" do
    visit root_path
    # Either redirected to login or welcome content not present
    expect(page).to (have_current_path(login_path) | have_no_content("Welcome"))
  end

  it "renders login page with fields and signup link" do
    visit login_path
    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
    expect(page).to have_button("Login")
    expect(page).to have_link("Sign up", href: signup_path)
  end

  it "logs in with valid credentials and redirects to welcome" do
    user = User.create!(user_attrs)
    visit login_path
    fill_in "Email", with: user.email_address
    fill_in "Password", with: user_attrs[:password]
    click_button "Login"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Welcome")
    expect(page).to have_link("Logout")
  end

  it "shows error for invalid login" do
    visit login_path
    fill_in "Email", with: "noone@example.com"
    fill_in "Password", with: "wrong"
    click_button "Login"

    expect(page).to have_current_path(login_path)
    expect(page).to have_content("Try another email address or password.")
    expect(page).to have_no_link("Logout")
  end

  it "signup link goes to signup page and can sign up successfully" do
    visit login_path
    click_link "Sign up"
    expect(page).to have_current_path(signup_path)

    fill_in "Email", with: "new@example.com"
    fill_in "Password", with: "securepass"
    fill_in "Confirm Password", with: "securepass"
    click_button "Sign Up"

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Welcome")
    expect(User.exists?(email_address: "new@example.com")).to be true
  end

  it "logs out and redirects to login" do
    user = User.create!(user_attrs)
    # log in
    visit login_path
    fill_in "Email", with: user.email_address
    fill_in "Password", with: user_attrs[:password]
    click_button "Login"

    click_link "Logout"
    expect(page).to have_current_path(login_path)
    expect(page).to have_no_content("Welcome")
    visit root_path
    expect(page).to (have_current_path(login_path) | have_no_content("Welcome"))
  end
end
