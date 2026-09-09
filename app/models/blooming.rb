class Blooming < ApplicationRecord
  belongs_to :plant
  has_many :photos, dependent: :destroy

  validates :in_full_bloom_date, presence: true

  after_save :update_plant_last_update_date

  private

  def update_plant_last_update_date
    plant.update_last_update_date
  end
end
