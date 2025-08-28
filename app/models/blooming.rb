class Blooming < ApplicationRecord
  belongs_to :plant
  has_many :photos, dependent: :destroy

  validates :in_full_bloom_date, presence: true
end
