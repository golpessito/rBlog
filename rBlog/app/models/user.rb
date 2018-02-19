class User < ApplicationRecord
  attr_accessor :password
  has_many :posts
  before_save :encrypt_password

  validates :name,  presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password, confirmation:true

  def self.search(query)
    where("name like ? OR email like ?", "%#{query}%","%#{query}%")
  end

  def self.authenticate(email,password)
    user=User.find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password,user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt=BCrypt::Engine.generate_salt
      self.password_hash=BCrypt::Engine.hash_secret(password,password_salt)
    end
  end

end
