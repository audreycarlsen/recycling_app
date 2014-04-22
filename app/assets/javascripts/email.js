$(document).ready(function() {
  $('.email-me-button').click(function() {
    if ($(".email-me-form").val() == "") {
      $(".email-error").html("Email field can't be blank.");
      return false;
    }
    else if (!$(".email-me-form").val().match(/\w+@\w+\.\w+/i)) {
      $(".email-error").html("Please enter a valid email address.");
      return false;
    }
    else {
      var locations_hash = {};

      var drop_off_rows = $('.drop_off_locations_table').find(".locations_row");
      if (drop_off_rows.length > 0 ) {
        var drop_off_array = [];

        $.each(drop_off_rows, function (i, location) {
          var data = $(location).data();

          var name      = data.name;
          var url       = data.url;
          var phone     = data.phone;
          var hours     = data.hours;
          var street    = data.street;
          var city      = data.city;
          var state     = data.state;
          var zipcode   = data.zipcode;
          var distance  = data.distance;

          var location_hash = {
            name:     name,
            url:      url,
            phone:    phone,
            hours:    hours,
            street:   street,
            city:     city,
            state:    state,
            zipcode:  zipcode,
            distance: distance
          }

          drop_off_array.push(location_hash);
        });
        locations_hash["drop_off"] = drop_off_array;
      }

      var pick_up_rows = $('.pick_up_locations_table').find(".locations_row");
      if (pick_up_rows.length > 0 ) {
        var pick_up_array = [];
        $.each(pick_up_rows, function (i, location) {
          var data = $(location).data();

          var name      = data.name;
          var url       = data.url;
          var phone     = data.phone;
          var hours     = data.hours;
          var street    = data.street;
          var city      = data.city;
          var state     = data.state;
          var zipcode   = data.zipcode;

          var location_hash = {
            name:     name,
            url:      url,
            phone:    phone,
            hours:    hours,
            street:   street,
            city:     city,
            state:    state,
            zipcode:  zipcode,
          }

          pick_up_array.push(location_hash);
        });
        locations_hash["pick_up"] = pick_up_array;
      }

      var mail_in_rows = $('.mail_in_locations_table').find(".locations_row");
      if (mail_in_rows.length > 0 ) {
        var mail_in_array = [];
        $.each(mail_in_rows, function (i, location) {
          var data = $(location).data();

          var name      = data.name;
          var url       = data.url;
          var phone     = data.phone;
          var hours     = data.hours;
          var street    = data.street;
          var city      = data.city;
          var state     = data.state;
          var zipcode   = data.zipcode;

          var location_hash = {
            name:     name,
            url:      url,
            phone:    phone,
            hours:    hours,
            street:   street,
            city:     city,
            state:    state,
            zipcode:  zipcode,
          };

          mail_in_array.push(location_hash);
        });
        locations_hash["mail_in"] = mail_in_array;
      }
        
      $("#loading-gif").show();

      $.ajax({
        type: "POST",
        url: "/email",
        data: {
          email_address:    $(".email-me-form").val(),
          materials:        $('#displayed-title').html(),
          current_location: $('#displayed_address').html(),
          locations:        locations_hash
        },
        success: function() {
          $(".email-error").html("");
          $(".email-notification").html("Email sent!");
          $("#loading-gif").hide();
          $(".email-me-form").val("");
        },
        error: function () {
          $(".email-error").html("There was an error with your request.");
          $(".email-me-form").val("");
          $("#loading-gif").hide();
        }
      });
      return false;
    }
  });
});