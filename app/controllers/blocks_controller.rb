class BlocksController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])
    @block = current_user.blocks.build(blocked_user: @user)

    if @block.save
      redirect_to people_path, notice: t("user.blocked_user_notice", username: @user.username)
    end
  end

  def destroy
    @user = User.find_by(username: params[:username])
    @block = current_user.blocks.where(blocked_id: @user.id)

    if @block.destroy_all
      redirect_to user_path(@user), notice: t("user.unblocked_user_notice", user: @user.username)
    end
  end
end
