class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def follow
    @user = User.find(params[:id])
    @followed = @user != current_user && (@user.followers << current_user)
    render status: @followed ? :ok : :unprocessable_entity
  end

  def unfollow
    @user = User.find(params[:id])
    @followed = !(@user != current_user && @user.followers.delete(current_user))
    render :follow, status: !@followed ? :ok : :unprocessable_entity
  end
end
