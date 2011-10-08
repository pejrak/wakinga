  $(document).ready(function() {

    //message hover and activate effects
    $(".post").live({
      mouseover: function () {
        var identificator = $(this).attr("id");
        $("#post_operators_"+identificator).show();
        $(this).css("background-color","#d1ffc0");
      },
      mouseout: function () {
        $(".post_operators").hide();
        $(this).css("background-color","transparent");
      },
      click: function() {
        var identificator = $(this).attr("id");
        $(".activated_post_container").html("<p><img src='/images/loader.gif'/> Loading...</p>");
        $.getScript("/posts/" + identificator + "/activate.js");
      }
    });


//fade out for notices after actions
  $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(10000);

});
