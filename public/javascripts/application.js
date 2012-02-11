// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

  $("#search").keyup(function() {
    var search_criteria = $("#search").serialize();
    var key_count = (search_criteria.length - 7);
    var interest_id = $("#dynamic_beads").attr("data-id")
    if (key_count > 1) {
        $.getScript("/beads.js?"+search_criteria+"&interest_id="+interest_id);
    }
  });

  //interest preview effects
    $(".preview_slot").live({
      mouseenter: function () {
        var identificator = $(this).attr("data-id");
//        $(".slot_full").show();
	$(".preview_slot").css("background-color","transparent");
        $(this).css("background-color","#E6E6E6");
        $("#interest_operators_"+identificator).show();
//        $(".slot_full").html("<p><img src='/images/loader.gif'/> Loading...</p>");
//	$.getScript("/interests/" + identificator + "/preview.js?full_refresh=true");
      },
      mouseleave: function () {
        $(".interest_operators").fadeOut();
      }
    });
    //generic operator preview
    $.getScript("/javascripts/preview_ops.js");
    $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(6000);
});
