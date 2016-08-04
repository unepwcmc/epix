class Organisation < ApplicationRecord
  has_many :users
  belongs_to :country
  has_one :adapter

  VALID_ROLES = ["CITES MA", "Customs EA", "System Managers", "Other"]
  validates :name, :role, :country, presence: true
  validates :name, uniqueness: true
  validates_inclusion_of :role, in: VALID_ROLES
end
