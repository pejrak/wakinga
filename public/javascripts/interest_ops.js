// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    $("#new_post").submitWithAjax();
      //post preview effects
    $(function() {
        var c=0;
//      if ($(".dynamic#post_content").length > 0) {
        setTimeout("updatePosts(0)", 1000);
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
      $(".dynamic#recalls").html("<p><img src='/images/loader.gif'/> Searching...</p>");
      $.getScript("/interests/"+interest_id+"/memory_search.js?"+search_criteria);
    }
  });
});

function updatePosts(c) {
  var t;
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  var after = $(".post:first").attr("data-time");
  $.getScript("/posts.js?interest_id=" + interest_id + "&after=" + after + "&full_refresh=false&previous_visit_record=" + previous_visit);
  $.getScript("/javascripts/message_ops.js");
  //iterating timeout count
  if (c == undefined) {
    var c = 0;
  }
  c=c+1;
  if (c<10) {
    t=setTimeout("updatePosts("+c+")", c*10000);
  }
  else {
    clearTimeout(t);
  }
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



