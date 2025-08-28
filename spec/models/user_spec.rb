require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email_address: "m@example.com", password: "password", password_confirmation: "password")
    expect(user).to be_valid
  end

  it "validates presence and uniqueness of email_address" do
    User.create!(email_address: "dup@example.com", password: "password", password_confirmation: "password")
    user = User.new(email_address: "dup@example.com", password: "password", password_confirmation: "password")
    expect(user).to_not be_valid
    expect(user.errors[:email_address]).to include("has already been taken")
  end

  it "enforces password length and confirmation" do
    user = User.new(email_address: "s@example.com", password: "a", password_confirmation: "a")
    expect(user).to_not be_valid
    expect(user.errors[:password]).to be_present
  end

  it "authenticates with correct password if using has_secure_password" do
    user = User.create!(email_address: "auth@example.com", password: "password", password_confirmation: "password")
    expect(user.authenticate("password")).to be_truthy
    expect(user.authenticate("wrong")).to be_falsey
  end
end
