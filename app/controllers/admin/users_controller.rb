class Admin::UsersController < AdminController
  before_action :find_user, only: [:show, :update, :edit, :destroy]
  def edit
    
  end
  
  def update
    if @user.update(params.require(:user).permit!)
      redirect_to admin_dashboard_path
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    redirect_to admin_dashboard_path, notice: "@#{@user.username} deleted!"
  end

  def index
  end
  
  private
  
  def find_user
    @user = User.find_by(username: params[:username])
  end
end
