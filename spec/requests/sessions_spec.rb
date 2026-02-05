require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { User.create!(email_address: "req@example.com", password: "password", password_confirmation: "password") }

  describe "GET /login" do
    it "renders the login page" do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Login")
    end

    it "allows unauthenticated access" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /login" do
    it "creates a session and redirects on valid credentials" do
      post login_path, params: {  email_address: user.email_address, password: "password" }
      expect(response).to redirect_to(plants_path)
      follow_redirect!
      expect(response.body).to include("Since Update")
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
