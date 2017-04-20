class Shipment < ApplicationRecord
  has_one :position, as: :shippable
  has_one :port, through: :position

  validates :hold_capacity, numericality: { greater_than: 0 }
  validates :title, :hold_capacity, presence: true
end
