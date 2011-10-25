// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    $("#new_post").submitWithAjax();
    $(function() {
        var c=0;
        setTimeout("updatePosts(0)", 1000);
        $.getScript("/javascripts/message_ops.js");
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
    $(".stream_operators").live({
      mouseover: function () {
        $(this).css("background-color","#d1ffc0");
      },
      mouseout: function () {
        $(this).css("background-color","#CCC");
      },
      click: function() {
        var interest_identificator = $(this).parent().attr("data-id");
        var identificator = $(this).attr("id");
        $(this).parent().data("load",identificator);
        prepPosts();
      }
    });
});

function updatePosts(c) {
  var t;
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  var after = $(".post:first").attr("data-time");
  //if message refresh is visible, remove it, so that it does not display during timed refresh
  if ($("#messagerefresh").length > 0) {
    $("#messagerefresh").remove();
  }
  $.getScript("/posts.js?iid=" + interest_id + "&after=" + after + "&full_refresh=false&pvr=" + previous_visit);
  //reload message operations scripts, because they get disabled by running multiple layers of scripts before
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
    $("#interest").after("<div id='messagerefresh'><a href='#' data-remote='true' onClick='updatePosts(0)'><img src='/images/message_refresh.png' border = 0 />refresh messages</a></div>");
  }
}

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
//submittal of post/messages form, making ajax request for the new messages
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })
  return this;
}

function prepPosts() {
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  var load_type = $("#catcher").data("load");
  $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(6000);
  $.getScript("/posts.js?iid=" + interest_id + "&full_refresh=true&pvr=" + previous_visit+"&lt=" + load_type);
  alert(load_type);
}
