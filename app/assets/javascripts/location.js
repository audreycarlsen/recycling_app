$(document).ready(function() {
  if ($("#map-canvas").length) {
    $.ajax({
      type: "GET",
      url: "/locations.json" + location.search,
      success: function(data) {
        var mapOptions = {
          center: new google.maps.LatLng(data["current_location"].latitude, data["current_location"].longitude),
          zoom: 11
        };

        var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

        var infoWindow = new google.maps.InfoWindow();

        $.each(data["drop_off_locations"], function (i, location) {
          var position = new google.maps.LatLng(data["drop_off_locations"][i].latitude, data["drop_off_locations"][i].longitude);

          var marker = new google.maps.Marker({
            position: position,
            map: map,
            icon: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
          });

          var windowContent = '<strong>' + data["drop_off_locations"][i].name + '</strong><br>' + data["drop_off_locations"][i].street + '<br>' + data["drop_off_locations"][i].city + ', WA ' + data["drop_off_locations"][i].zipcode + '<br>' + data["drop_off_locations"][i].distance

          google.maps.event.addListener(marker, 'click', function() {
            infoWindow.setContent(windowContent);
            infoWindow.open(map, this);
          });
        });

        var position = new google.maps.LatLng(data["current_location"].latitude, data["current_location"].longitude);
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
  }
});