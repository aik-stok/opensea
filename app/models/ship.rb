class Ship < ApplicationRecord
  has_many :positions, as: :shippable
  has_many :ports, through: :positions

  validates :hold_capacity, numericality: { greater_than: 0 }
  validates :title, :hold_capacity, presence: true
end
