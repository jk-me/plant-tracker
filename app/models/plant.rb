class Plant < ApplicationRecord
  belongs_to :user
  has_many :bloomings, dependent: :destroy
  has_many :photos, dependent: :destroy

  validates :name, presence: true
end
