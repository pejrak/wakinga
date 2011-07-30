// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    //initiate sliders and hiders for content effects
    $('.slider').click(function() {
      $('.content_'+$(this).attr('id')).slideToggle('slow');
  });

    $('.hider').click(function() {
      $('.content_'+$(this).attr('id')).toggle();
  });
  //interest preview effects
    $(".preview_slot").hover(
      function () {
        var identificator = $(this).attr("data-id");
        $(".slot_full").show();
        $("#interest_operators_"+identificator).show();
        $(".slot_full").html("<p>Loading...</p>");
	$.getScript("/interests/" + identificator + "/preview.js?full_refresh=true");
      },
      function () {
        $(".slot_full").hide();
        $(".interest_operators").fadeOut();
      }
    );
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

    $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(10000);
});

function hideSlot() {
    
}


