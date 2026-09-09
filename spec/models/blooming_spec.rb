require 'rails_helper'

RSpec.describe Blooming, type: :model do
  describe 'update plant last_update_date when modified' do
    let(:user) { User.create!(email_address: "tes3t@example.com", password: "password") }
    let(:plant) { Plant.create!(name: "Test Plant", user: user) }
    let(:blooming) { Blooming.create(plant: plant, in_full_bloom_date: Date.today) }

    it 'updates the plant last_update_date after saving' do
      old_last_update_date = plant.last_update_date
      travel 1.day

      blooming.in_full_bloom_date = Date.today
      blooming.save

      expect(plant.reload.last_update_date).to be > old_last_update_date

      # plant papertrail ignores last_update_date, so the version should still be created
      expect(plant.versions.count).to eq(1)
      expect(plant.versions.last.event).to eq('create')
    end
  end
end
