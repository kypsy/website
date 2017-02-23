class LatLngsSerializer
  def initialize(collection)
    @collection = collection
  end

  def to_h
    {lat_lngs: collection}
  end

  def collection
    @collection.map {|ll| {
      id:       ll.id,
      lat:      ll.lat,
      lng:      ll.lng,
      username: ll.username,
      location: ll.location,
      avatar:   ll.avatar,
      user_id:  ll.user_id
    } }
  end

end
