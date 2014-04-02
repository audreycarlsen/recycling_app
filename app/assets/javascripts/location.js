$(document).ready(function() {
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
      
      var map = L.map('map', { scrollWheelZoom: false }).setView([position.coords.latitude, position.coords.longitude], 13);

      var mapquestLayer = new L.TileLayer('http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
        maxZoom: 18,
        attribution: 'Data, imagery and map information provided by <a href="http://open.mapquest.co.uk" target="_blank">MapQuest</a>,<a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and contributors.',
        subdomains: ['otile1','otile2','otile3','otile4']
      });

      map.addLayer(mapquestLayer);

      var marker = L.marker([position.coords.latitude, position.coords.longitude]).addTo(map);
    }
    
  });
});