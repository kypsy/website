window.kypsy ||= {}
$ ->
  window.kypsy.appUrl = $("#map").data("api-url")
class @LatLng
  constructor: (ll) ->
    @id       = ll.id
    @lat      = ll.lat
    @lng      = ll.lng
    @username = ll.username
    @location = ll.location
    @avatar   = ll.avatar
    @user_id   = ll.user_id

  latLng: () ->
    new google.maps.LatLng(this.lat, this.lng)

  userContent: () ->
    {
      username: this.username,
      avatar:   this.avatar,
      location: this.location,
      user_id:  this.user_id
    }

  @currentLatLng: () ->
    myLatLng = $("#map").data('current-lat-lng')
    myLatLng ||= [-34.397, 150.644]
    new google.maps.LatLng(myLatLng[0], myLatLng[1])

  @all: () ->
    url = window.kypsy.appUrl + "/lat_lngs"
    $.ajax url
    .then (response) ->
      $.map response.lat_lngs, (ll) ->
        new LatLng(ll)
