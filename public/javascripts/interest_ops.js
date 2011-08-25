// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    $("#new_post").submitWithAjax();
      //post preview effects
    $(function() {
//      if ($(".dynamic#post_content").length > 0) {
        setTimeout(updatePosts, 1000);
//      }
    });
    $(function() {
      $(".activated_post_container").jScroll();
    });
});

function updatePosts() {
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#post_content").attr("data-time");
//  if ($(".post").length > 0) {
    var after = $(".post:first").attr("data-time");
//  } else {
//    var after = "0";
//  }
  $.getScript("/posts.js?interest_id=" + interest_id + "&after=" + after + "&full_refresh=false" + "&previous_visit_record=" + previous_visit);
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
  var previous_visit = $(".dynamic#post_content").attr("data-time");
  $("#flash_notice, #flash_error").fadeOut(10000);
  $.getScript("/posts.js?interest_id=" + interest_id + "&full_refresh=true" + "&previous_visit_record=" + previous_visit);
}



