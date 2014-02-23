class Address < ActiveRecord::Base
  field :line1

  belongs_to :user
end
Address.auto_upgrade!
