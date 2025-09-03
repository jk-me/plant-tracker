require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create!(email_address: "req@example.com", password: "password", password_confirmation: "password") }

  describe "POST /login" do
    it "creates a session and redirects on valid credentials" do
      post login_path, params: {  email_address: user.email_address, password: "password" }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Welcome")
      expect(Session.last.user).to eq(user)
    end

    it "re-renders or returns error on invalid credentials" do
      post login_path, params: { email_address: user.email_address, password: "bad" }
      expect(response).to have_http_status(:redirect)
      expect(Session.last).to be_nil
    end
  end

  describe "DELETE /logout" do
    it "clears the session and redirects to login" do
      # set session
      post login_path, params: {  email_address: user.email_address, password: "password" }
      delete session_path
      expect(Session.last).to be_nil
      expect(response).to redirect_to(login_path)
    end
  end
end
