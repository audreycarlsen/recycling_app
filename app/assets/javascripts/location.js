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

          var windowContent = '<strong>' + data[i].name + '</strong><br>' + data[i].street + '<br>' + data[i].city + ', WA ' + data[i].zipcode + '<br>' + data[i].distance

          google.maps.event.addListener(marker, 'click', function() {
            infoWindow.setContent(windowContent);
            infoWindow.open(map, this);
          });

          bounds.extend(position);
        });

        map.fitBounds(bounds);
      }
    });
  }
});