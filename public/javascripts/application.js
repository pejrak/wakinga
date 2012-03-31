//complex search for memories and minds
$(document).ready(function() {
  $("#mindsearch").keyup(function() {
    var search_criteria = $("#mindsearch").serialize();
    var key_count = (search_criteria.length - 11);
    if (key_count > 2) {
      $(".dynamic#recalls").html("<p><img src='/images/loader.gif'/> Searching...</p>");
      $.getScript("/mind_search.js?"+search_criteria);
    }
  });
    //initiate sliders and hiders for content effects
    $('.slider').click(function() {
      $('.content_'+$(this).attr('id')).slideToggle('slow');
  });

    $('.hider').click(function() {
      $('.content_'+$(this).attr('id')).toggle();
  });
//search for concepts
  $("#search").keyup(function() {
    var search_criteria = $("#search").serialize();
    var key_count = (search_criteria.length - 7);
    var interest_id = $("#dynamic_beads").attr("data-id")
    if (key_count > 1) {
        $.getScript("/beads.js?"+search_criteria+"&interest_id="+interest_id);
    }
  });
  //comment post-add loader
  $("body").delegate("#comment_body", "keypress", function(e) {
      code=(e.keyCode ? e.keyCode : e.which);
      if (code == 13) {
          //test if this event is entered# alert("enter was pressed");
          $(".comments_content_container").append("<p><img src='/images/loader.gif'/> Adding comment...</p>");
          $("#comment_body").hide();
      }
  });

  //interest preview effects
    $(".preview_slot").live({
      mouseenter: function () {
        var identificator = $(this).attr("data-id");
	$(".preview_slot").css("background-color","transparent");
        $(this).css("background-color","#E6E6E6");
        $(".interest_operators",this).show();
        //$("#interest_operators_"+identificator).show();
      },
      mouseleave: function () {
        $(".interest_operators").fadeOut();
      }
    });
    //handle effect after post submission
    $("#post_submit").click(function() {
       $(".content_create_message").append("<p id='postsubmission'><img src='/images/loader.gif'/> Adding message...</p>");
       $(this).hide();
    });
    //generic operator preview
    $.getScript("/javascripts/preview_ops.js");
    $("#flash_notice, #flash_error, .flash_dynamic, #flash_alert").fadeOut(7000);
});
