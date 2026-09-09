class Plant < ApplicationRecord
  has_paper_trail ignore: [ :last_update_date ]

  belongs_to :user
  has_many :bloomings, dependent: :destroy
  has_many :photos, dependent: :destroy

  validates :name, presence: true

  after_save :update_last_update_date

  def update_last_update_date
    update_column(:last_update_date, Time.current)
  end
end
