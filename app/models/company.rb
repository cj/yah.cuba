class Company < ActiveRecord::Base
  col :name

  has_one :address, as: :addressable, dependent: :destroy

  validates :name, presence: true

  validates_associated :address
end
Company.auto_upgrade!
