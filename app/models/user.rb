class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organisation

  # TODO: placeholder for model attribute
  def first_name
    'John'
  end

  # TODO: placeholder for model attribute
  def last_name
    'Doe'
  end

  # TODO: placeholder for model attribute
  def is_admin
    true
  end

  # TODO: placeholder for model attribute
  def organisation
    'CITES Management Authority of Wonderland'
  end
end
