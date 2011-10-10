  $(document).ready(function() {

    //bead hover and activate effects
    $(".bead_point").live({
      mouseover: function () {
        var identificator = $(this).attr("data-id");
        if ($(".bead_point_container").length == 0) {
          $(this).append("<div class='bead_point_container' data-id="+identificator+">hello</div>");
        }
        $("#bead_operators_"+identificator).show();
        $(this).css("background-color","#d1ffc0");
      },
      mouseout: function () {
        $(".bead_operators").hide();
        $(this).css("background-color","transparent");
      },
      click: function() {
        var identificator = $(this).attr("data-id");
        $(".activated_bead_container#"+identificator).html("<p><img src='/images/loader.gif'/> Loading...</p>");
        $.getScript("/bead_point_load.js?load_type=bead_point&bead_id="+identificator);
      }
    });
});
