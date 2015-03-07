class User < ActiveRecord::Base
  has_many :recipes

  validates :email, :username, uniqueness: true
  validates :first_name, :last_name, :email, :password, :username, presence: true

  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self.password == password
  end

end
