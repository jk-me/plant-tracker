class Plant < ApplicationRecord
  belongs_to :user
  has_many :bloomings, dependent: :destroy
  has_many :pictures, dependent: :destroy

  validates :name, presence: true
end
