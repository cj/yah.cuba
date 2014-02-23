class User < ActiveRecord::Base
  field :first_name
  field :last_name

  has_many :posts
end
User.auto_upgrade!
