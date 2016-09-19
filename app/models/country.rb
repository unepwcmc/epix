class Country < ApplicationRecord
  has_many :organisations

  scope :with_organisations, -> {
    joins(:organisations).where('organisations.country_id IS NOT NULL').uniq
  }
end
