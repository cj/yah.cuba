class User < ActiveRecord::Base
  col :first_name
  col :last_name

  belongs_to :company

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates_associated :company
end
User.auto_upgrade!
