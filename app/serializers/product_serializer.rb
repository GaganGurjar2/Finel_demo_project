class ProductSerializer < ActiveModel::Serializer
   attributes :id, :name, :category, :price, :user_id,:images
  def images
    object.image.url
  end
end
 