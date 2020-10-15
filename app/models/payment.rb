class Payment < ApplicationRecord
  has_many :orders, dependent: false
end
