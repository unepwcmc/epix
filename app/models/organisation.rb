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
  validates :name, uniqueness: {scope: :country}
  validates :role, uniqueness: {scope: :country}
  validates_inclusion_of :role, in: VALID_ROLES

  scope :cites_mas, -> {
    where(role: CITES_MA)
  }
  scope :with_available_adapters, -> {
    joins(:adapter).where('adapters.is_available' => true)
  }

  accepts_nested_attributes_for :adapter

  def display_name
    if [CITES_MA, CUSTOMS_EA].include?(role) && country.present?
      [role, 'of', country.name].join(' ')
    else [SYSTEM_MANAGERS, OTHER].include? role
      name
    end
  end

  def is_cites_ma?
    role == CITES_MA
  end

end
