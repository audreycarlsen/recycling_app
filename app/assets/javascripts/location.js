$(document).ready(function() {
  if ($("#map-canvas").length) {

    var current_location = $("#map-canvas").data("current-location");

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
        var phone     = data.phone;
        var url       = data.url;
        var hours     = data.hours;
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

        if (data.url) {
          var data_link = '<strong><a href="' + data.url + '" target="_blank">' + data.name + '</a></strong><br>';
        }
        else {
          var data_link = '<strong>' + data.name + '</strong><br>';
        }

        var windowContent = data_link + data.phone + '<br>' + data.street + '<br>' + data.city + ', ' + data.state + ' ' + data.zipcode + '<br><em>' + data.distance + '</em>'

        google.maps.event.addListener(marker, 'click', function() {
          infoWindow.setContent(windowContent);
          infoWindow.open(map, this);
        });
      });

      var position = new google.maps.LatLng(current_location[0], current_location[1]);
      var marker = new google.maps.Marker({
        position: position,
        map: map,
        icon: 'https://storage.googleapis.com/support-kms-prod/SNP_2752068_en_v0'
      });
      var windowContent = "You are here!";
      google.maps.event.addListener(marker, 'click', function() {
        infoWindow.setContent(windowContent);
        infoWindow.open(map, this);
      });

      infoWindow.setContent(windowContent);
      infoWindow.open(map, marker);
  }
});