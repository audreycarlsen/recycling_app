$(document).ready(function() {
  $('.location').click(function () {
    var lon = document.querySelector('.long');
    var lat = document.querySelector('.lat');
    var error = document.querySelector('.error');

    { 
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
      } else {
        error.innerHTML = "Geolocation is not supported by this browser.";
      }
    }
    
    function showPosition(position) {
      lat.innerHTML = "Latitude: " + position.coords.latitude;
      lon.innerHTML = 'Longitude:' + position.coords.longitude;
    }
  });
});
