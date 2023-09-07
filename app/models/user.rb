class User < ApplicationRecord
  has_many :product  
  has_many :purchase
  validates :user_name, presence: true
  validates :password, length: { minimum: 8 }, format: { with: /\A\S+\z/ }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :user_type, inclusion: { in: ['seller', 'buyer'],message: "Invalid User Type," }     
end
