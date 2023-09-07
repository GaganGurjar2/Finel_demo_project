class Product < ApplicationRecord
  belongs_to :users         #Seller_type_user
  has_many :purchase       #Buyer_type_user
  validate :seller_add_product
  private
  def seller_add_product
    if user.present? && user.user_type != 'seller'
      errors.add(:user,"only seller add product")
    end 
  end
end
