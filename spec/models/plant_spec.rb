require "rails_helper"

RSpec.describe Plant, type: :model do
  let(:user) { User.create!(email_address: "owner@example.com", password: "password", password_confirmation: "password") }
  it "uses PaperTrail to record changes to repotted_date" do
    plant = user.plants.create!(name: "Brassavola nodosa")

    expect { plant.update!(repotted_date: Date.new(2026, 9, 6)) }.to change { plant.versions.count }.by(1)

    expect(plant.versions.last.changeset.fetch("repotted_date")).to eq([ nil, Date.new(2026, 9, 6) ])
  end

  it "updates last_update_date when other fields are modified" do
    plant = user.plants.create!(name: "Brassavola nodosa")
    old_last_update_date = plant.last_update_date

    travel 1.day do
      plant.update!(location: "New Location")
    end

    expect(plant.reload.last_update_date).to be > old_last_update_date
  end

  it "does not update last_update_date when only last_update_date is modified" do
    plant = user.plants.create!(name: "Brassavola nodosa")
    old_last_update_date = plant.last_update_date

    travel 1.day do
      plant.update_column(:last_update_date, Time.current)
    end

    expect(plant.versions.count).to eq(1)
    expect(plant.versions.last.event).to eq('create')
    expect(plant.reload.last_update_date).to be > old_last_update_date
  end
end
