# frozen_string_literal: true

# UsersController - description needed
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not final implementation!
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App #{@user.name}!"
      # Rails auto infers that we want to redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
