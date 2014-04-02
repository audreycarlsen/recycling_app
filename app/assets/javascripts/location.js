$(document).ready(function() {

  var map = L.map('map', { scrollWheelZoom: false }).setView([47.608, -122.333], 11);

  var mapquestLayer = new L.TileLayer('http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: 'Data, imagery and map information provided by <a href="http://open.mapquest.co.uk" target="_blank">MapQuest</a>,<a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and contributors.',
    subdomains: ['otile1','otile2','otile3','otile4']
  });

  map.addLayer(mapquestLayer);

  $('.location').click(function() {

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
      
      map.setView([position.coords.latitude, position.coords.longitude], 14);

      L.marker([position.coords.latitude, position.coords.longitude]).addTo(map);
    }

    $.ajax({
      type: "GET",
      url: "/locations.json",
      success: function(data) {
        console.log(data);
        var dataLayer = L.geoJson(data);
        map.addLayer(dataLayer);
      }
    });
  });
});