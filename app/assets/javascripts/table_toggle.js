$(document).ready(function() {
  $('.locations_table').on('click', '.locations_row', function(event) {
    $(this).siblings("#desc_" + this.id).toggle();
    $(this).find("span").toggle();
  });

  $('.pick_up_tab').click(function() {
    $('#map-canvas').addClass("opaque");
    $('.hover-text').html('Pick-up locations not displayed.');
    $('.hover-text').show();
  });

  $('.mail_in_tab').click(function() {
    $('#map-canvas').addClass("opaque");
    $('.hover-text').html('Mail-in locations not displayed.');
    $('.hover-text').show();
  });
  
  $('.drop_off_tab').click(function() {
    $('#map-canvas').removeClass("opaque");
    $('.hover-text').hide();
  });
});