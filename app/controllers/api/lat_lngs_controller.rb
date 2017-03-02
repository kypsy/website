class Api::LatLngsController < ApplicationController
  def index
    @lat_lngs = LatLng.visible.includes(user: :photos)
    render json: LatLngsSerializer.new(@lat_lngs).to_h
  end
end
