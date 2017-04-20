class Position < ApplicationRecord
  belongs_to :shippable, polymorphic: true
  belongs_to :port

  validates :opened_at, presence: true
end
