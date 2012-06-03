  $(document).ready(function() {

    //message hover and activate effects
$("body").delegate(".post","mouseout",function(){
  $(this).css("background-color","transparent");
        $(".post_operators").hide();

});

$("body").delegate(".post","mouseover",function(){
        var identificator = $(this).attr("id");
        $("#post_operators_"+identificator).show();
  if ($(this).hasClass("expanded_post") == false) {
    $(this).css("background-color","#d1ffc0");
  }
});


$("body").delegate(".post","click",function(){
  if ($(this).hasClass("expanded_post") == false) {
  $(".post").animate({
    width:"44%"
  }, 500);
  $("p",".post").animate({
    fontSize:"12px"
  }, 500);
  $(".activated_post_container").remove();  

  $(this).animate({
    width:"94%"
  }, 500);
  $("p",this).animate({
    fontSize:"18px"
  }, 500);
  var identificator = $(this).attr("id");
  $(this).toggleClass("expanded_post");

  $(this).append("<div class='activated_post_container'><p><img src='/images/loader.gif'/> Loading...</p></div>");

  $.getScript("/posts/" + identificator + "/activate.js");
  }

});


//fade out for notices after actions
  $("#flash_notice, #flash_error, .flash_dynamic").fadeOut(10000);

});
