class Organisation < ApplicationRecord
  has_many :users
  belongs_to :country
  has_one :adapter

  CITES_MA = 'CITES MA'
  CUSTOMS_EA = 'Customs EA'
  SYSTEM_MANAGERS = 'System Managers'
  OTHER = 'Other'
  VALID_ROLES = [CITES_MA, CUSTOMS_EA, SYSTEM_MANAGERS, OTHER]
  validates :name, :role, :country, presence: true
  validates :name, uniqueness: {scope: [:country, :role]}
  validates_inclusion_of :role, in: VALID_ROLES

  def display_name
    if [CITES_MA, CUSTOMS_EA].include?(role) && country.present?
      [role, 'of', country.name].join(' ')
    elsif [SYSTEM_MANAGERS, OTHER].include? role
      name
    else
      role
    end
  end

end
