class Admin::PhotosController < AdminController

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to admin_dashboard_path, notice: "Deleted Photo"
  end
end
