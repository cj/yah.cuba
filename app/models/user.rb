class User < ActiveRecord::Base
  field :first_name
  field :last_name

  has_many :posts
  has_one :address
end
User.auto_upgrade!
