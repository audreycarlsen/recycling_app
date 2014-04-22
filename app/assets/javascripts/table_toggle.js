$(document).ready(function() {
  $('.locations_table').on('click', '.locations_row', function(event) {
    $(this).siblings("#desc_" + this.id).toggle();
    $(this).find("span").toggle();
  });
});