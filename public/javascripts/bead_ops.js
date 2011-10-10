  $(document).ready(function() {
    //bead hover and activate effects
    $(".bead_point").live({
      mouseenter: function () {
        var identificator = $(this).attr("data-id");
        $(this).css("background-color","#d1ffc0");
      },
      mouseleave: function () {
        var identificator = $(this).attr("data-id");
        $(this).css("background-color","transparent");
      },
      click: function() {
      var identificator = $(this).attr("data-id");
        //$(this).parent().css("background-color","#d1ffc0");
        var parent_ids = $(this).parent().data("beadpoints");
        var active_array = $.merge([identificator], parent_ids);
        //$(this).data("beadpoints", [identificator]);
        if ($(this).parent().attr("class")=="bead_point_container") {
          var initializer = "true";
          if ($(".bead_group#beadpoint"+identificator).length==0) {
            $(this).after("<div class='bead_group' id='beadpoint"+identificator+"' data-id="+identificator+"></div>");
          }
          $("#beadpoint"+identificator).html("<p><img src='/images/loader.gif'/> Loading...</p>");
          $.getScript("/bead_point_load.js?bead_id="+identificator+"&beads_in_path="+active_array+"&initialize="+initializer);
        }
        else {
          var initializer = "false";
        }
      }
    });
    
    $(".bead_point_container").live({
      mouseenter: function () {
        var identificator = $(this).attr("data-id");
        $(this).data("beadpoints", identificator);
        //$(this).append("<p>node: "+$(this).data("beadpoints")+"</p>") 
      },
      mouseleave: function () {
        var identificator = $(this).attr("data-id");
//        $(".bead_operators").hide();
        $(this).css("background-color","transparent");
        $("#beadpoint"+identificator).remove();
      }
    });

});
