class Order < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true }
  validates :total, presence: true, numericality: true
  validates :user_id, presence: true
  validates :purchase_id, presence: true

  belongs_to :user
  belongs_to :purchase
end
