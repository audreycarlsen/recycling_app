$(document).ready(function() {
  $('.email-me-button').click(function() {
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

    $.ajax({
      type: "POST",
      url: "/email",
      data: {
        email_address: $(".email-me-form").val(),
        locations: locations_array
      },
      success: function(data) {
        console.log("email success!");
      }
    });
    return false;
  });
});