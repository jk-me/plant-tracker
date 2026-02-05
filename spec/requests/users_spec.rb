require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "POST /users (signup)" do
    it "creates a user and redirects to welcome on valid data" do
      expect {
        post users_path, params: {  email_address: "signup@example.com", password: "password", password_confirmation: "password" }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(plants_path)
      follow_redirect!
      expect(response.body).to include("Logged in as")
      expect(response.body).to include("signup@example.com")
    end

    it "does not create user with invalid data and shows errors" do
      expect {
        post users_path, params: { user: { email_address: "bad", password: "1", password_confirmation: "2" } }
      }.to_not change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
