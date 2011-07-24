// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    $("#new_post").submitWithAjax();

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
        $(".interest_operators").hide();
      }
    );
    //generic operator preview
    $(".item_with_operators").hover(
      function () {
        var identificator = $(this).attr("data-id");
        $("#operators_" + identificator).show();
      },
      function () {
        $(".operators").hide();
      }
    );

    $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(10000);
});


$(function() {
  if ($(".dynamic#post_content").length > 0) {
    setTimeout(updatePosts, 10000);
  }
});

function updatePosts() {
  var interest_id = $("#interest").attr("data-id");
  if ($(".post").length > 0) {
    var after = $(".post:first-child").attr("data-time");
  } else {
    var after = "0";
  }
  $.getScript("/posts.js?interest_id=" + interest_id + "&after=" + after + "&full_refresh=false");
  setTimeout(updatePosts, 10000);


}

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

function prepPosts() {
  var interest_id = $("#interest").attr("data-id");
  $("#flash_notice, #flash_error").fadeOut(10000);
  $.getScript("/posts.js?interest_id=" + interest_id + "&full_refresh=true");
}
