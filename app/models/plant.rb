class Plant < ApplicationRecord
  has_paper_trail

  belongs_to :user
  has_many :bloomings, dependent: :destroy
  has_many :photos, dependent: :destroy

  validates :name, presence: true
end
