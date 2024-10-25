# frozen_string_literal: true

# UsersController - description needed
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
end
