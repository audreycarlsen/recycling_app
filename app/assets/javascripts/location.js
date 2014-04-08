$(document).ready(function() {
  if ($("#map-canvas").length) {
    var mapOptions = {
      center: new google.maps.LatLng(47.608, -122.333),
      zoom: 9
    };
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

    var infoWindow = new google.maps.InfoWindow();

    $.ajax({
      type: "GET",
      url: "/locations.json" + location.search,
      success: function(data) {
        var bounds = new google.maps.LatLngBounds ();
        
        $.each(data, function (i, location) {
          var position = new google.maps.LatLng(data[i].latitude, data[i].longitude);

          var marker = new google.maps.Marker({
            position: position,
            map: map,
            icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
          });

          var windowContent = '<strong>' + data[i].name + '</strong><br>' + data[i].street + '<br>' + data[i].city + ', WA ' + data[i].zipcode

          google.maps.event.addListener(marker, 'click', function() {
            infoWindow.setContent(windowContent);
            infoWindow.open(map, this);
          });

          bounds.extend(position);
        });

        map.fitBounds(bounds);
      }
    });

    $('.current_location').click(function() {

      var lon = document.querySelector('.long');
      var lat = document.querySelector('.lat');
      var error = document.querySelector('.error');

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
      } else {
        error.innerHTML = "Geolocation is not supported by this browser.";
      }

      function showPosition(position) {
        lat.innerHTML = "Latitude: " + position.coords.latitude;
        lon.innerHTML = 'Longitude: ' + position.coords.longitude;
        
        var myCoords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        mapOptions = {
          zoom: 13,
          center: myCoords
        }

        var marker = new google.maps.Marker({
          position: myCoords,
          map: map,
          title: "Current Location",
          icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
        });

        google.maps.event.addListener(marker, 'click', function() {
          infoWindow.setContent('Current Location');
          infoWindow.open(map, this);
        });
      }
    });
  }
});