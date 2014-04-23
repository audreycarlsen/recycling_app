function showPosition(position) {
  $.ajax({
    type: "GET",
    url: "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + position.coords.latitude + "," + position.coords.longitude + "&sensor=false",
    success: function(data) {
      $('#address_field').val(position.coords.latitude + "," + position.coords.longitude);
      $('#displayed_address_field').val("near: " + data.results[0].address_components[0].short_name + " " + data.results[0].address_components[1].short_name + ", " + data.results[0].address_components[3].short_name + ", " + data.results[0].address_components[5].short_name + " " + data.results[0].address_components[7].short_name);
      $(".invalid_address").html('');
      $('.loading-gif1').hide();
    }
  });
}

function watchCurrentLocation() {
  $('.current_location').click(function() {
    var invalid = document.querySelector('.invalid_address');
    $('.loading-gif1').show();

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition, function(error) {
        alert("Check your browser and system settings to enable location services.");
      });
    } else {
      invalid_address.innerHTML = "Geolocation is not supported by this browser. Please type in your location by hand.";
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
    if($("input:checked").length == 0) {
      $(".invalid_address").html("Please select at least one material");
      return false;
    }

    if ($('#displayed_address_field').val() === '') {
      $(".invalid_address").html("Please provide an address!");
      return false;
    }
    else {
      $('.loading-gif2').show();

      var address = $('#displayed_address_field').val().replace(/\s/g, '+');

      $.ajax({
        type: "GET",
        url: "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&sensor=false",
        success: function(data) {
          if (data["status"] == "ZERO_RESULTS") {
            $(".invalid_address").html("Invalid address");
            $('.loading-gif2').hide();
            return false;
          }
          else {
            $('#address_field').val(data.results[0].geometry.location.lat + "," + data.results[0].geometry.location.lng);
            $('#displayed_address_field').val(data.results[0].formatted_address);

            var v = $('#displayed_address_field').val();

            if (v.indexOf('USA')!=-1 || v.indexOf('Canada')!=-1) {
              $(".invalid_address").html('');
              $('.onward-button').click();
            } else {
              $(".invalid_address").html("Please enter a location in the U.S. or Canada");
              $('.loading-gif2').hide();
              return false;
            }
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

          setTimeout(function (){
            $(document.body).scrollTop($('#hr-anchor').offset().top);
          }, 500);

          $("#material_result").replaceWith(html);
          $("#error").html("");
          watchCurrentLocation();
          watchCheckboxes();
          watchOnwardButton();
          if ( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
            $('.learn-more').popover({trigger: 'click'})
          } else {
            $('.learn-more').popover({trigger: 'hover'});
          }
        }
      });
    };

    function watchForChange() {
      $('.select_box').change(
        update
      );
    }

    $('.search_button').click(function(e) {
      e.preventDefault();
      update();
      watchForChange();
      $("#error").html("");
    });
  }
});