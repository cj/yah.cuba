class User < ActiveRecord::Base
  include Shield::Model

  col :first_name, :last_name, :email, :crypted_password
  fake :password, as: :string

  belongs_to :company


  validates :email, presence: true
  validates :first_name, :last_name, presence: true
  validates :password, :crypted_password, on: :create, presence: true

  after_validation :clear_password

  def password= pass
    self.crypted_password = Shield::Password.encrypt(pass.to_s)
  end

  class << self
    def [] id
      User.find id
    end

    def fetch email
      if user = User.where(email: email)
        user.first
      else
        false
      end
    end
  end

  private

  def clear_password
    @password = ''
  end
end
User.auto_upgrade!
