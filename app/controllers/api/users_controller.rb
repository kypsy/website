class Api::UsersController < ApplicationController
  def index
    @users = User.visible.adults.where(params.permit!.slice(:label_id))

    render json: UsersSerializer.new(@users).to_h
  end

  def show
    @user = User.visible.adults.find(params[:id])
    render json: UserSerializer.new(@user).to_h
  end

end
