$(document).ready(function() {
    //generic operator preview
    $("body").delegate(".item_with_operators","hover",function() {
      $(".operators").fadeOut();
      var identificator = $(this).attr("data-id");
      $("#operators_" + identificator).show();
    });
});
