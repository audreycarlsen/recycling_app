$(document).ready(function() {
  var source = $("#material-result-template").html();
  var template = Handlebars.compile(source);

  $('.search_button').click(function() {
    var id = $("#material option:selected").val();

    $.ajax({
      type: "GET",
      url: "/materials/" + id,
      success: function(data) {
        var html = template(data);
        $("#material_result").replaceWith(html);
      }
    });
    return false;
  });
});