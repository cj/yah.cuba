class User < ActiveRecord::Base
  field :title
end
User.auto_upgrade!
