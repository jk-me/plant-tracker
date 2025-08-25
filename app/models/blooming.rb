class Blooming < ApplicationRecord
  belongs_to :plant
  has_many :pictures, dependent: :destroy

  validates :flowers_fully_open_date, presence: true
end
