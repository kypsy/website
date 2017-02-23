class RedFlagsController < ApplicationController

  def create
    @flag = current_user.red_flag_reports.new(flaggable_id: params[:id], flaggable_type: params.require(:red_flag)[:flaggable_type])
    flash[:notice] = @flag.save ? "Flagged!" : "Already flagged"
    redirect_to user
  end

  def destroy
    @flag = current_user.red_flag_reports.find(params[:id])
    @flag.destroy
    redirect_to user, notice: "Unflagged!"
  end

  private

  def user
    @user ||= @flag.flaggable_type == "User" ? @flag.flaggable : @flag.flaggable.user
  end
end
