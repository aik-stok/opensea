class Port < ApplicationRecord
  has_many :positions
  has_many :shipments, through: :positions
  has_many :ships, through: :positions

  validates :title, :lat, :lng, presence: true
  validates :lat, uniqueness: { scope: :lng }
end
