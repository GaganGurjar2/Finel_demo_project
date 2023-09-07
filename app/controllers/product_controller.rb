class ProductController < ApplicationController
  def create
    if @current_user.user_type == "seller"
      product= Product.new(product_params)
      if product.save
        render json: product
      else
        render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "You do not have permission to add product" }, status: :unauthorized
    end
  end
  private      
  def product_params
      params.require(:product).permit(:name,:category,:price,:user_id)
  end   
end
