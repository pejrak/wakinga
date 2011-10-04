$(document).ready(function() {
    //generic operator preview
    $(".item_with_operators").hover(
      function () {
        var identificator = $(this).attr("data-id");
        $("#operators_" + identificator).show();
      },
      function () {
          $(".operators").fadeOut();
      }
    );
});
