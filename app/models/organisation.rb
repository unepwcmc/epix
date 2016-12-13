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

  def can_access_adapter?(other_organisation)
    self.is_system_managers? || self.country_id == other_organisation.country_id
  end

  def display_name
    if [CITES_MA, CUSTOMS_EA].include?(role) && country.present?
      [role, 'of', country.name].join(' ')
    else [SYSTEM_MANAGERS, OTHER].include? role
      name
    end
  end

  VALID_ROLES.each do |role|
    role_formatted = role.downcase.tr(" ", "_")
    define_method("is_#{role_formatted}?") do
      self.role == role
    end
  end

end
