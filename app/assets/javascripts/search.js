function showPosition(position) {
  $.ajax({
    type: "GET",
    url: "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude + "&sensor=false",
    success: function(data) {
      $('#address_field').val(position.coords.latitude + "," + position.coords.longitude);
      $('#displayed_address_field').val("near: " + data.results[0].address_components[0].short_name + " " + data.results[0].address_components[1].short_name + ", " + data.results[0].address_components[3].short_name + ", " + data.results[0].address_components[5].short_name + " " + data.results[0].address_components[7].short_name);
      $(".invalid_address").html('');
    }
  });
}

function watchCurrentLocation() {
  $('.current_location').click(function() {
    var error = document.querySelector('.error');

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else {
      error.innerHTML = "Geolocation is not supported by this browser. Please type in your location by hand.";
    }
  });
}

function watchCheckboxes() {
  $('.watched-checkbox').click(function() {
    $('.checkbox-all').children('input').attr('checked', false);
  });

  $('.checkbox-all').click(function() {
    $('.watched-checkbox').children('input').attr('checked', false);
  });
}

function watchOnwardButton() {
  $('.dummy-onward-button').click(function() {
    if ($('#displayed_address_field').val() === '') {
      $(".invalid_address").html("Please provide an address!");
      return false;
    }
    else {
      $('.loading-gif').toggle();

      var address = $('#displayed_address_field').val().replace(/\s/g, '+');

      $.ajax({
        type: "GET",
        url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false",
        success: function(data) {
          if (data["status"] == "ZERO_RESULTS") {
            $(".invalid_address").html("Invalid address :(");
            $('.loading-gif').toggle();
            return false;
          }
          else {
            $('#address_field').val(data.results[0].geometry.location.lat + "," + data.results[0].geometry.location.lng);
            $('#displayed_address_field').val(data.results[0].formatted_address);
            $(".invalid_address").html('');
            $('.onward-button').click();
          }
        }
      });
    }
  });
}

$(document).ready(function() {
  if ($("#material-result-template").length) {
    var source = $("#material-result-template").html();
    var template = Handlebars.compile(source);

    var update = function() {
      var id = $("#material option:selected").val();

      $.ajax({
        type: "GET",
        url: "/materials/" + id,
        success: function(data) {
          var html = template(data);
          $("#material_result").replaceWith(html);
          watchCurrentLocation();
          watchCheckboxes();
          watchOnwardButton();
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