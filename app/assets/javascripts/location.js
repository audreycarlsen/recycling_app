$(document).ready(function() {
  if ($("#map-canvas").length) {

    var current_location = $("#drop_off_table").data("current-location");

      var mapOptions = {
        scrollwheel: false,
        center: new google.maps.LatLng(current_location[0], current_location[1]),
        zoom: 11
      };

      var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

      var infoWindow = new google.maps.InfoWindow();

      var rows = $('#drop_off_table tbody').find("tr");

      $.each(rows, function (i, location) {
        var data = $(location).data();

        var name      = data.name;
        var street    = data.street;
        var city      = data.city;
        var state     = data.state;
        var zipcode   = data.zipcode;
        var distance  = data.distance;
        var latitude  = parseFloat(data.latitude);
        var longitude = parseFloat(data.longitude);

        var position = new google.maps.LatLng(latitude, longitude);

        var marker = new google.maps.Marker({
          position: position,
          map: map,
          icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
        });

        var windowContent = '<strong>' + data.name + '</strong><br>' + data.street + '<br>' + data.city + ', ' + data.state + ' ' + data.zipcode + '<br>' + data.distance

        google.maps.event.addListener(marker, 'click', function() {
          infoWindow.setContent(windowContent);
          infoWindow.open(map, this);
        });
      });

      var position = new google.maps.LatLng(current_location[0], current_location[1]);
      var marker = new google.maps.Marker({
        position: position,
        map: map,
        icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
      });
      var windowContent = "YOU ARE HERE!";
      google.maps.event.addListener(marker, 'click', function() {
        infoWindow.setContent(windowContent);
        infoWindow.open(map, this);
      });

  }
});