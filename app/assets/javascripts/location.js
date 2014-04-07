$(document).ready(function() {

// GOOGLE MAPS MAIN VIEW
  function initialize() {
    var mapOptions = {
      center: new google.maps.LatLng(47.608, -122.333),
      zoom: 9
    };
    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

    $.ajax({
      type: "GET",
      url: "/locations.json" + location.search,
      success: function(data) {
        $.each(data, function (i, location) {
          var position = new google.maps.LatLng(data[i].latitude, data[i].longitude);
          var marker = new google.maps.Marker({
            position: position,
            map: map,
            title: "Hello world!"
          });
        })
      }
    });
  }

  google.maps.event.addDomListener(window, 'load', initialize);

// CURRENT LOCATION VIEW
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
      var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

      var marker = new google.maps.Marker({
        position: myCoords,
        map: map,
        title:"Current Location"
      });
    }
  });

  // LEAFLET
  // var map = L.map('map', { scrollWheelZoom: false }).setView([47.608, -122.333], 11);

  // var mapquestLayer = new L.TileLayer('http://{s}.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.png', {
  //   maxZoom: 18,
  //   attribution: 'Data, imagery and map information provided by <a href="http://open.mapquest.co.uk" target="_blank">MapQuest</a>,<a href="http://www.openstreetmap.org/" target="_blank">OpenStreetMap</a> and contributors.',
  //   subdomains: ['otile1','otile2','otile3','otile4']
  // });

  // map.addLayer(mapquestLayer);



  // $.ajax({
  //   type: "GET",
  //   url: "/locations.json",
  //   success: function(data) {
  //     var dataLayer = L.geoJson(data, {
  //       onEachFeature: function(feature, layer) {
  //         layer.bindPopup(feature.properties.name);
  //       }
  //     });
  //     map.addLayer(dataLayer);
  //   }
  // });

  // $('.submit_address').click(function() {
  //   $.ajax({
  //   type: "GET",
  //   url: google api url,
  //   success: function(data) {
  //     var dataLayer = L.geoJson(data, {
  //       onEachFeature: function(feature, layer) {
  //         layer.bindPopup(feature.properties.name);
  //       }
  //     });
  //     map.addLayer(dataLayer);
  //   }
  // });

  //   map.setView([position.coords.latitude, position.coords.longitude], 14);
  // //   L.marker([position.coords.latitude, position.coords.longitude]).addTo(map);
  // });
});