require "rails_helper"

RSpec.describe Plant, type: :model do
  it "uses PaperTrail to record changes to repotted_date" do
    user = User.create!(email_address: "owner@example.com", password: "password", password_confirmation: "password")
    plant = user.plants.create!(name: "Brassavola nodosa")

    expect { plant.update!(repotted_date: Date.new(2026, 9, 6)) }.to change { plant.versions.count }.by(1)

    expect(plant.versions.last.changeset.fetch("repotted_date")).to eq([ nil, Date.new(2026, 9, 6) ])
  end
end
