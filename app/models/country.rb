class Country < ActiveRecord::Base
  has_one :adapter
  has_many :organisations
end
