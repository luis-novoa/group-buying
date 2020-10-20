class Payment < ApplicationRecord
  has_many :orders, dependent: false
  belongs_to :user
end
