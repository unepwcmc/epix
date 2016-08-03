class Organisation < ApplicationRecord
  has_many :users
  belongs_to :country

  VALID_ROLES = ["CITES MA", "Customs EA", "CITES Secretariat", "UNEP-WCMC"]
  validates :name, :role, :country, presence: true
  validates :name, uniqueness: true
  validates_inclusion_of :role, in: VALID_ROLES
end
