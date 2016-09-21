class Country < ApplicationRecord
  has_many :organisations

  scope :with_organisations, -> {
    joins(:organisations).where("organisations.role <> 'System Managers'").distinct
  }
end
