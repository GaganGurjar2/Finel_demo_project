class UsersController < ApplicationController
    before_action :find_user, only: [:show, :update, :destroy]
    skip_before_action :authenticate_request, only: [:create, :user_login]
	def index
		users =User.all
		render json:users
	end

	def show 
		render json:@user 
  end

	def create
		user = User.new(user_params)
		if user.save
			render json: user, status: :created
    else
      render json: {errors: user.errors.full_messages}          		
	  end
  end
  def user_login
    if user = User.find_by(email: params[:email], password: params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { message: "Logged In Successfully..", token: token }
    else
      render json: { error: "Please Check email And Password....." }
    end
  end

	def update
		@user.update(user_params)
	  render json: @user
  end 
   
  def destroy
   	@user.destroy
   	head :no_content
  end  
  private
  def user_params
    params.require(:user).permit(:user_name,:email,:password, :user_type)
  end
  def find_user
    @user =User.find(params[:id])
    unless @user
      render json: "User not found.."
    end
  end
end
