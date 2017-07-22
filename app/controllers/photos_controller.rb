class PhotosController < ApplicationController
  before_action :require_login, except: :email
  skip_before_action :verify_authenticity_token, only: :email

  before_action :set_photo,                     only: [:edit, :update, :destroy]
  before_action :confirm_photo_belongs_to_user, only: [:edit, :update, :destroy]

  def new
    @slug  = "settings"
    @title = t("titles.new_photo", brand: t(:brand))
    @user  = current_user
    @facebook = Social::Facebook.new(current_user)
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.new(photos_params)
    if @photo.save
      redirect_to person_path(current_user.username)
    else
      render :new
    end
  end

  def edit
    @slug  = "settings"
    @title = t("titles.edit_photo", brand: t(:brand))
  end

  def update
    @photo.update(photos_params)
    redirect_to person_path(current_user.username)
  end

  def destroy
   @photo.destroy
   redirect_to person_path(current_user.username)
  end

  def email
    data = JSON.parse(params[:mandrill_events]) if params[:mandrill_events]

    return head(:ok) if params[:mandrill_events].nil? || data.empty?

    intake = MandrillIntake.new(data[0])

    if intake.photo.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def confirm_photo_belongs_to_user
    unless @photo.user == current_user
      redirect_to root_path, notice: t("photos.not_your_photo")
    end
  end

  def photos_params
    params.require(:photo).permit(:remote_image_url, :caption, :image, :avatar, manipulate: [:rotate, :flip, :flop])
  end

end
