class MapController < ApplicationController
  def index
    @slug = "map-container"
    @lat_lng = LatLng.find_by(user_id: current_user.id) if current_user
    @lat_lngs = LatLng.adults.visible
  end
end
