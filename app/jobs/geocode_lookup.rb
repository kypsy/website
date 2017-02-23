class GeocodeLookup
  extend HerokuResqueAutoscaler if Rails.env.production?

  @queue = :geocode_lookup

  def self.perform(id)
    @user = User.find(id)
    LatLng.where(user_id: @user.id).destroy_all
    return true if @user.city.blank? && @user.zipcode.blank?
    address = "#{@user.city} #{@user.state} #{@user.zipcode} #{@user.country.try(:name)}".strip
    geocode = Geocode.new(address)
    lat_lng = LatLng.new(geocode.lat_lng)
    lat_lng.user_id = @user.id
    lat_lng.username = @user.username
    lat_lng.location = address
    lat_lng.avatar = @user.avatar
    lat_lng.save!
  end

end
