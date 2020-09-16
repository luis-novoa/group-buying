class Order < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :total, presence: true, numericality: true
  validates :delivery_city, presence: true, inclusion: { in: %w[Sinop Cuiabá] }
  validates :user_id, presence: true
  validates :purchase_id, presence: true

  belongs_to :user
  belongs_to :purchase
end
