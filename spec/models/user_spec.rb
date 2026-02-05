require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email_address: "m@example.com", password: "password", password_confirmation: "password")
    expect(user).to be_valid
  end

  describe "email_address validations" do
    it "requires email_address presence" do
      user = User.new(email_address: nil, password: "password", password_confirmation: "password")
      expect(user).to_not be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it "enforces email_address uniqueness" do
      User.create!(email_address: "dup@example.com", password: "password", password_confirmation: "password")
      user = User.new(email_address: "dup@example.com", password: "password", password_confirmation: "password")
      expect(user).to_not be_valid
      expect(user.errors[:email_address]).to include("has already been taken")
    end

    it "normalizes email_address to lowercase" do
      user = User.create!(email_address: "TEST@EXAMPLE.COM", password: "password", password_confirmation: "password")
      expect(user.email_address).to eq("test@example.com")
    end

    it "strips whitespace from email_address" do
      user = User.create!(email_address: "  test@example.com  ", password: "password", password_confirmation: "password")
      expect(user.email_address).to eq("test@example.com")
    end

    it "is case-insensitive for uniqueness" do
      User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      user = User.new(email_address: "TEST@EXAMPLE.COM", password: "password", password_confirmation: "password")
      expect(user).to_not be_valid
      expect(user.errors[:email_address]).to include("has already been taken")
    end
  end

  describe "password validations" do
    it "requires password presence" do
      user = User.new(email_address: "test@example.com", password: nil, password_confirmation: nil)
      expect(user).to_not be_valid
      expect(user.errors[:password]).to be_present
    end

    it "enforces minimum password length of 5 characters" do
      user = User.new(email_address: "s@example.com", password: "a", password_confirmation: "a")
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 5 characters)")
    end

    it "allows password of exactly 5 characters" do
      user = User.new(email_address: "s@example.com", password: "abcde", password_confirmation: "abcde")
      expect(user).to be_valid
    end

    it "allows password longer than 5 characters" do
      user = User.new(email_address: "s@example.com", password: "verylongpassword", password_confirmation: "verylongpassword")
      expect(user).to be_valid
    end

    it "requires password_confirmation match" do
      user = User.new(email_address: "test@example.com", password: "password", password_confirmation: "different")
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to be_present
    end
  end

  describe "authentication" do
    it "authenticates with correct password using has_secure_password" do
      user = User.create!(email_address: "auth@example.com", password: "password", password_confirmation: "password")
      expect(user.authenticate("password")).to be_truthy
    end

    it "fails authentication with incorrect password" do
      user = User.create!(email_address: "auth@example.com", password: "password", password_confirmation: "password")
      expect(user.authenticate("wrong")).to be_falsey
    end
  end

  describe "associations" do
    it "has many sessions" do
      user = User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user.sessions).to be_empty
    end

    it "has many plants" do
      user = User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      expect(user.plants).to be_empty
    end

    it "destroys dependent sessions on user deletion" do
      user = User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      user.sessions.create!(user_agent: "Mozilla", ip_address: "127.0.0.1")
      expect { user.destroy }.to change { Session.count }.by(-1)
    end

    it "destroys dependent plants on user deletion" do
      user = User.create!(email_address: "test@example.com", password: "password", password_confirmation: "password")
      user.plants.create!(name: "Brassavola nodosa")
      expect { user.destroy }.to change { Plant.count }.by(-1)
    end
  end
end
