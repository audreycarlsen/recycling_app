$(document).ready(function() {
  $('.location-table').on('click', '.locations_row', function(event) {
    $(this).siblings("#desc_" + this.id).toggle();
    $(this).find(".glyphicon").toggle();
  });

  $('.pick_up_tab').click(function() {
    $('#map-canvas').fadeTo( "slow", 0.25 );
    $('.hover-text').html('Pick-up locations not displayed.');
    $('.hover-text').show();
  });

  $('.mail_in_tab').click(function() {
    $('#map-canvas').fadeTo( "slow", 0.25 );
    $('.hover-text').html('Mail-in locations not displayed.');
    $('.hover-text').show();
  });
  
  $('.drop_off_tab').click(function() {
    $('#map-canvas').fadeTo( "slow", 1 );
    $('.hover-text').hide();
  });
});