$(document).ready(function() {
  if ($("#material-result-template").length) {
    var source = $("#material-result-template").html();
    var template = Handlebars.compile(source);

    var update = function() {
      var id = $("#material option:selected").val();

      $('.search_button').innerHTML = "Loading...";

      $.ajax({
        type: "GET",
        url: "/materials/" + id,
        success: function(data) {
          var html = template(data);
          $("#material_result").replaceWith(html);
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