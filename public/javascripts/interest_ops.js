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

  $("#memorysearch").keyup(function() {
    var search_criteria = $("#memorysearch").serialize();
    var key_count = (search_criteria.length - 13);

    var interest_id = $("#interest").attr("data-id")
    if (key_count > 2) {
      $(".slot_full").html("<p><img src='/images/loader.gif'/> Searching...</p>");
      $.getScript("/interests/"+interest_id+"/memory_search.js?"+search_criteria);
    }
  });

});

function updatePosts() {
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
//  if ($(".post").length > 0) {
    var after = $(".post:first").attr("data-time");
//  } else {
//    var after = "0";
//  }
  $.getScript("/posts.js?interest_id=" + interest_id + "&after=" + after + "&full_refresh=false&previous_visit_record=" + previous_visit);
  setTimeout(updatePosts, 20000);


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
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  $("#flash_notice, #flash_error").fadeOut(10000);
  $.getScript("/posts.js?interest_id=" + interest_id + "&full_refresh=true&previous_visit_record=" + previous_visit);
}



