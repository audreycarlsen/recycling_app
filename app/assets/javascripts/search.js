function showPosition(position) {
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json?latlng=47.608933099999994,-122.3333873&sensor=false")
  debugger;
  address_string = response.
  $('#address_field').attr('value', position.coords.latitude + "," + position.coords.longitude);
  // var myCoords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
  // mapOptions = {
  //   zoom: 13,
  //   center: myCoords
  // }

  // var marker = new google.maps.Marker({
  //   position: myCoords,
  //   map: map,
  //   title: "Current Location",
  //   icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
  // });

  // google.maps.event.addListener(marker, 'click', function() {
  //   infoWindow.setContent('Current Location');
  //   infoWindow.open(map, this);
  // });
}

function watchCurrentLocation() {
  $('.current_location').click(function() {
    var error = document.querySelector('.error');

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      error.innerHTML = "Geolocation is not supported by this browser.";
    }

    // AJAX GOES HURRRR

  });
}

$(document).ready(function() {
  if ($("#material-result-template").length) {
    var source = $("#material-result-template").html();
    var template = Handlebars.compile(source);

    var update = function() {
      var id = $("#material option:selected").val();

      $('.search_button').innerHTML = "Loading...";

      $.ajax({
        type: "GET",
        url: "/materials/" + id,
        success: function(data) {
          var html = template(data);
          $("#material_result").replaceWith(html);
          watchCurrentLocation();
        }
      });
      return false;
    };

    $('.search_button').click(
      update
    );

    $('.select_box').change(
      update
    );
  }
});