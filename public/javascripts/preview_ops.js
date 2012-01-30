$(document).ready(function() {
    //generic operator preview
    $(".item_with_operatorss").hover(
      function () {
        var identificator = $(this).attr("data-id");
        $("#operators_" + identificator).show();
      },
      function () {
          $(".operators").fadeOut();
      }
    );
});
