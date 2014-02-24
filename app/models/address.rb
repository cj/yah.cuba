class Address < ActiveRecord::Base
  col :line1, :line2, :city, :state
  col :zip, as: :integer

  belongs_to :addressable, polymorphic: true

  validates :line1, :city, :state, :zip, presence: true
end
Address.auto_upgrade!
