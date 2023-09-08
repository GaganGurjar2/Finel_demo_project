class ProductsController < ApplicationController
  before_action :current_user_product, only: [:show ,:destroy,:update] 
  
  # ..................See All Products......................
  def index
    if seller
      products = @current_user.products
      if products.present?
        render json: products
      else
        render json: { message: "No product exists" }
      end
    elsif buyer
      products = Product.all
      if products.present?
        render json: products
      else
        render json: { message: "No product exists for buying" } 
      end
    end      
  end

  # ..................Create Product......................
  def create
    if seller
      product= Product.new(product_params)
      if product.save
        render json: { message: "Product Created", data: product }
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Only Seller Type User Add Product" }, status: :unauthorized
    end
  end
  
  # ..................Update Product......................
  def update
    if seller
      if @product.update(product_params)
        render json: { message: 'Updated successfully......', data: @product }
      else
        render json: { errors: @product.errors.full_messages }
      end
    else
      render json: { message: "Only Seller Type User update Product" }, status: :unauthorized    
    end
  end

  # ..................Show Product......................
  def show
    if seller
      render json: @product
    elsif buyer
      product=Product.find_by(id: params[:id])
      render json: product
    end    
  end  

  # ..................Delete Product......................
  def destroy
    if seller
      if @product.destroy
        render json: { message: 'Deleted successfully......', data: @product }
      else
        render json: { errors: @product.errors.full_messages }
      end
    else
      render json: { message: "Only Seller Type User Delete Product" }, status: :unauthorized    
    end
  end 

  # ..................Product Search by Name......................
  def search_product_by_name
    if params[:name].present?
      product = Product.where('name like ?',params[:name].strip )
      if product.empty?
        render json: { message: 'No product found...' }
      else
        render json: product
      end
    end
  end

  # ..................Product Search by Category......................
  def search_product_by_category
    if buyer
      if params[:category].present?
        product = Product.where('category like ?', params[:category].strip )
        if product.empty?
          render json: { message: 'No product found...' }
        else
          render json: product
        end
      end
    else 
      render json: { message: 'No Only buyer type user can see...' }  
  end

  private       
  def product_params
    params.require(:product).permit(:name,:category,:price,:user_id)
  end

  def seller
    @current_user.user_type == "seller"
  end

  def buyer
    @current_user.user_type == "buyer"
  end 

  def current_user_product 
    @product = Product.find_by(id: params[:id] ,user_id: @current_user.id )
  end  
end

