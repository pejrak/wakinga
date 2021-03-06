$(document).ready(function() {
    //message creation effects
    jQuery.ajaxSetup({
      'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    });
    //submittal of post/messages form, making ajax request for the new messages
  jQuery.fn.submitWithAjax = function() {
    this.submit(function() {
      $.post(this.action, $(this).serialize(), null, "script");
//      this.after("<p><img src='/images/loader.gif'/> Adding comment...</p>");
      return false;
    })
    return this;
  }

  $("#new_post").submitWithAjax();

//message privacy switching
$("body").delegate(".privacy_ops_indicator","click",function(){
  parent_container = $(this).parent();
  if ($(parent_container).hasClass("personal_privacy")) {
    $(parent_container).removeClass("personal_privacy");
    $(parent_container).addClass("open_privacy");
    $("#post_p_private").val(0);
    $(this).html("Open message");
    $(".memory_contribution_container").show();
  }
  else if ($(parent_container).hasClass("open_privacy")) {
    $(parent_container).removeClass("open_privacy");
    $(parent_container).addClass("private_privacy");
    $("#post_p_private").val(1);
    $(this).html("Private message");
  }
  else if ($(parent_container).hasClass("private_privacy")) {
    $(parent_container).removeClass("private_privacy");
    $(parent_container).addClass("personal_privacy");
    $("#post_p_private").val(2);
    $(this).html("Personal message");
    $(".memory_contribution_container").hide();
  }
});


    //message hover and activate effects
$("body").delegate(".post","mouseout",function(){
  //$(this).css("background-color","transparent");
  $(this).removeClass("hovered");
        $(".post_operators").hide();

});

$("body").delegate(".post","mouseover",function(){
        var identificator = $(this).attr("id");
        $("#post_operators_"+identificator).show();
  if ($(this).hasClass("expanded_post") == false) {
    //$(this).css("background-color","#d1ffc0");
    $(this).addClass("hovered");
  }
});


$("body").delegate(".post","click",function(){
  

  if ($(this).hasClass("expanded_post") == false) {
  $(".post").animate({width:"44%"}, 500, function(){
    $(".post").css("border","none");
  });
  $("p",".post").animate({fontSize:"12px"}, 500);
  $(".activated_post_container").remove(); 
  $(".post").removeClass("expanded_post");
 

  $(this).animate({width:"94%"}, 500, function(){
    $(this).css("border","4px solid #d1ffc0");
  });
  $("p",this).animate({fontSize:"22px"}, 500);
  var identificator = $(this).attr("id");
  $(this).append("<div class='activated_post_container'><p><img src='/images/loader.gif'/> Loading...</p></div>");
  $.getScript("/posts/" + identificator + "/activate.js");
  $(this).toggleClass("expanded_post");
  }
});


//fade out for notices after actions
  $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(10000);

});
