$(document).ready(function() {

    $(function() {
        var c=0;
        //setTimeout("updatePosts(0)", 500);
        //$.getScript("/javascripts/message_ops.js");
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
    $("body").delegate(".stream_operator,.filter_operator", "click", function() {
        var identificator = $(this).attr("id");
        var loaded_set = $("#catcher").data("load");
        var selected_operator_class = $(this).attr("class");
        var operator_type = selected_operator_class.substr(0, selected_operator_class.length - 9);
        loaded_set[operator_type] = identificator;
        if (identificator == "streammessages") {
          loaded_set["filter"] = "filterall";
        }
        if (identificator == "streammemories") {
          loaded_set["filter"] = "filteractive";
        }
        $(".dynamic#postcontent").prepend("<p><img src='/images/loader.gif'/> Switching...</p>");
        prepPosts();
    });

    $("body").delegate(".stream_operator, .filter_operator", "mouseout", function() {
        var identificator = $(this).attr("id");
        var loaded_set = $("#catcher").data("load");
        var selected_operator_class = $(this).attr("class");
        var operator_type = selected_operator_class.substr(0, selected_operator_class.length - 9);
        if (identificator != loaded_set[operator_type]) {
          $(this).css("background-color","transparent");
        }
    });


    $("body").delegate(".stream_operator, .filter_operator", "mouseover", function() {
      $(this).css("background-color","#d1ffc0");
    });

});

function updatePosts(c) {
  t = null;
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  var after = $(".lastpost#stamper").attr("data-time");
  //if message refresh is visible, remove it, so that it does not display during timed refresh
  if ($("#messagerefresh").length > 0) {
    $("#messagerefresh").remove();
  }
  if ($("#catcher").data("load")==undefined) {
    $("#catcher").data("load",{"stream":"streammemories","filter":"filteractive"});
  }
  var load_type = $("#catcher").data("load")["stream"];
  var filter_type = $("#catcher").data("load")["filter"];
//check if this is the first refresh
  if (c==0) {
    var initial_load = 1;
  }
  else {
    var initial_load = 0;
  }
  $.getScript("/posts.js?iid="+interest_id+"&after="+after+"&full_refresh=false&pvr="+previous_visit+"&lt="+load_type+"&ft="+filter_type+"&il="+initial_load);
  //reload message operations scripts, because they get disabled by running multiple layers of scripts before
  //iterating timeout count
  //if (c == undefined) {
  //  var c = 0;
  //}
  //c=c+1;
  //if (c<10) {
  //  t=setTimeout("updatePosts("+c+")", c*10000);
  //}
  //else {
  //  clearTimeout(t);
  //  $("#interest").after("<div id='messagerefresh'><a href='#' data-remote='true' onClick='updatePosts(0)'><img src='/images/message_refresh.png' border = 0 />refresh messages</a></div>");
  //}
}

function prepPosts() {
  var interest_id = $("#interest").attr("data-id");
  var previous_visit = $(".dynamic#postcontent").attr("data-time");
  var load_type = $("#catcher").data("load")["stream"];
  var filter_type = $("#catcher").data("load")["filter"];
  $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(6000);
  $.getScript("/posts.js?iid=" + interest_id + "&full_refresh=true&pvr="+previous_visit+"&lt="+load_type+"&ft="+filter_type+"&il=1");
  //alert(load_type);
}
