class Partner < ApplicationRecord
  before_save :capitalize_first_letter
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 }
  validates :official_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 75 }
end
