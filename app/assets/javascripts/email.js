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
      var locations_array = [];

      var drop_off_rows = $('#drop_off_table tbody').find("tr:lt(5)");
      $.each(drop_off_rows, function (i, location) {
        var data = $(location).data();

        var name      = data.name;
        var street    = data.street;
        var city      = data.city;
        var state     = data.state;
        var zipcode   = data.zipcode;
        var distance  = data.distance;

        var location_hash = {
          name: name,
          street: street,
          city: city,
          state: state,
          zipcode: zipcode,
          distance: distance
        }

        locations_array.push(location_hash);
      });

      $("#loading-gif").show();

      $.ajax({
        type: "POST",
        url: "/email",
        data: {
          email_address: $(".email-me-form").val(),
          locations: locations_array
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
        }
      });
      return false;
    }
  });
});