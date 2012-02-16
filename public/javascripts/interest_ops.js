$(document).ready(function() {
    $("#new_post").submitWithAjax();
    $(function() {
        var c=0;
        setTimeout("updatePosts(0)", 500);
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
          var identificator = $(this).attr("id");
          var loaded_type = $("#catcher").data("load");
          if (identificator != loaded_type) {
              $(this).css("background-color","#CCC");
          }
      },
      click: function() {
        //var interest_identificator = $(this).parent().attr("data-id");
        var identificator = $(this).attr("id");
        $(this).parent().data("load",identificator);
        $(".dynamic#postcontent").prepend("<p><img src='/images/loader.gif'/> Switching message stream...</p>");
        $(".dynamic#memories").prepend("<p><img src='/images/loader.gif'/> Switching memory stream...</p>");
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
  if ($("#catcher").data("load")==undefined) {
    $("#catcher").data("load", "openmessages");
  }
  var load_type = $("#catcher").data("load");
//check if this is the first refresh
  if (c==0) {
    var initial_load = 1;
  }
  else {
    var initial_load = 0;
  }
  $.getScript("/posts.js?iid="+interest_id+"&after="+after+"&full_refresh=false&pvr="+previous_visit+"&lt="+load_type+"&il="+initial_load);
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
  $.getScript("/posts.js?iid=" + interest_id + "&full_refresh=true&pvr="+previous_visit+"&lt="+load_type+"&il=1");
  //alert(load_type);
}
