class Picture < ApplicationRecord
  belongs_to :plant
  belongs_to :blooming, optional: true

  validates :image_url, presence: true
end
