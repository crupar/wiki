class UsersController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:welcome]

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def upgrade
    @user = User.find(params[:id])
    authorize user
    redirect_to new_subscription_path
  end

  def downgrade
    current_user.update_attributes(role: 'standard')
    redirect_to edit_user_registration_path
  end

  def new
    @user = User.new
  end


  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
    def secure_params
      params.require(:user).permit(:role)
    end



end
