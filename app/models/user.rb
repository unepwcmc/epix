class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation

  validates :first_name, :last_name, presence: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def can_access_adapter?(country_id)
    self.is_system_managers? || self.organisation.country_id == country_id
  end

  Organisation::VALID_ROLES.each do |role|
    role_formatted = role.downcase.tr(" ", "_")
    define_method("is_#{role_formatted}?") do
      self.organisation.role == role
    end
  end

end
