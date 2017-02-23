# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
maxZoom = 12
window.kypsy = {}
template = $('#js-user-card').html()

window.kypsy.markersArray = () ->
  Object.values(this.markers)


resizeMap = ->
  offset = 60
  $('.filters').css(width: $(window).width() - 250)
  $("#map").css(height: $(window).height() - offset, top: offset)

$ ->
  if (typeof(google) != "undefined")
    $('.show-filters-button').click ->
      $(this).toggleClass("active")
      $(".filters").toggle()
      false

    resizeMap()

    $(window).resize ->
      resizeMap()

    initialize = ->
      window.kypsy.markers = {}
      window.kypsy.infowindow = new google.maps.InfoWindow { content: ""}

      styles = [{
        textColor: 'white',
        url: $("#map").data("small-icon"),
        height: 55,
        width: 56
      }, {
        textColor: 'white',
        url: $("#map").data("medium-icon"),
        height: 55,
        width: 56
      }, {
        textColor: 'white',
        url: $("#map").data("large-icon"),
        height: 55,
        width: 56
      }]

      options = {maxZoom: maxZoom, styles: styles}
      mapOptions = {
        center: LatLng.currentLatLng(),
        zoom: 6,
        maxZoom: maxZoom
      }

      map = new google.maps.Map(document.getElementById("map"),mapOptions)
      markerClusterer = new MarkerClusterer(map, window.kypsy.markersArray(), options)

      LatLng.all().then (data) ->
        for ll in data
          addMarker(ll.latLng(), map, ll.userContent())
      .then () ->
        markerClusterer.addMarkers window.kypsy.markersArray()

      google.maps.event.addListener map, 'click', ->
        if !window.kypsy.openCluster
          window.kypsy.infowindow.close()
        window.kypsy.openCluster = false

      google.maps.event.addListener markerClusterer, 'clusterclick', (cluster) ->
        if markerClusterer.map.zoom == maxZoom
          content = ""
          $.each cluster.getMarkers(), (i, marker) ->
            content += marker.content

          marker = cluster.getMarkers()[0]
          window.kypsy.openCluster = true
          window.kypsy.infowindow.setContent(infoWindowContent(content))
          latLng = new google.maps.LatLng(marker.position.lat(), marker.position.lng())
          window.kypsy.infowindow.setPosition(latLng)
          window.kypsy.infowindow.open(map)

      $(".user-filter").change () ->
        User.where($(".filter")).then (users) ->
          markers = []
          markerClusterer.clearMarkers()
          $.each users, (index, user) ->
            marker = window.kypsy.markers[user.id]
            if marker then markerClusterer.addMarker(marker)

    google.maps.event.addDomListener(window, 'load', initialize)


    infoWindowContent = (content) ->
      "<ul class='js-user-container info-window'>" + content + "</ul>"

    addMarker = (latLng, map, user) ->
      Mustache.parse(template)
      rendered = Mustache.render(template, user)
      marker = new google.maps.Marker {
        position: latLng,
        content: rendered,
        user_id: user.user_id
      }
      window.kypsy.markers[user.user_id] = marker

      google.maps.event.addListener marker, 'click', ->
        window.kypsy.infowindow.setContent infoWindowContent(marker.content)
        window.kypsy.infowindow.open(map,marker)
