class CrushesController < ApplicationController
  before_action :require_login
  before_action :find_user_by_username
  respond_to :html, :json

  def create
    crush = current_user.crushings.build(crushee: @user)
    unless redirect_if_age_inappropriate(crush.crushee)
      crush.save!
      crush.notify if crush.needs_notify?
      respond_with(@user, location: person_path(@user.username))
    end
  end

  def destroy
    find_user_by_username
    current_user.crushings.where(crushee_id: @user.id).destroy_all
    respond_with(@user, location: person_path(@user.username))
  end

end
