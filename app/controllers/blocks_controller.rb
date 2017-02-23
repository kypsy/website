class BlocksController < ApplicationController
  def create
    @user = User.find_by(username: params[:username])
    @block = current_user.blocks.build(blocked_user: @user)

    if @block.save
      redirect_to people_path,
                  notice: "Blocked! You will no longer see @#{@user.username} unless you go directly to their profile page.
                           (Or you can <a href='/@#{@user.username}/unblock' class='unblock' data-method='delete'>unblock @#{@user.username}</a> now.)"
    end
  end

  def destroy
    @user = User.find_by(username: params[:username])
    @block = current_user.blocks.where(blocked_id: @user.id)

    if @block.destroy_all
      redirect_to user_path(@user),
                  notice: "Un-blocked! You'll now see @#{@user.username} normally as you would anyone else."
    end
  end
end
