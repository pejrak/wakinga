//complex search for memories and minds
$(document).ready(function() {
  var timer = null;
  $("#mindsearch").keyup(function() {
    $(".dynamic#recalls").html("");
    var search_criteria = $("#mindsearch").serialize();
    var key_count = (search_criteria.length - 11);
    if (key_count > 2) {
        if (timer) {
            clearTimeout(timer);
        }
        timer = setTimeout(function() {
            searchContent(search_criteria)
        }, 1000);
      function searchContent(search_criteria) {
        $(".dynamic#recalls").html("<p><img src='/images/loader.gif'/> Searching...</p>");
        $.getScript("/mind_search.js?"+search_criteria);
      }
      
    }
  });
  //quick user search
  $("body").delegate("#mindfinder","keyup", function() {
    var search_criteria = $("#mindfinder").serialize();
    //var search_criteria_length = $("#mindfinder").val().length;
    var key_count = $("#mindfinder").val().length;
    if (key_count > 2) {
      $(".found_minds").html("<p><img src='/images/loader.gif'/> Searching...</p>");
      var interest_id = $("#interest").attr("data-id");
      $.getScript("/mind_finder.js?"+search_criteria+"&iid="+interest_id);
    }
  });
    //auto expand handler for message creation
    $("#post_content").autogrow();
    //initiate sliders and hiders for content effects
    $('body').delegate(".slider","click", function() {
      $('.content_'+$(this).attr('id')).slideToggle('slow');
    });

    $('body').delegate(".hider","click", function() {
      $('.content_'+$(this).attr('id')).toggle();
    });
//search for concepts
  $("#search").keyup(function() {
    var search_criteria = $("#search").serialize();
    var key_count = (search_criteria.length - 7);
    var interest_id = $("#dynamic_beads").attr("data-id")
    if (key_count > 1) {
        $.getScript("/beads.js?"+search_criteria+"&interest_id="+interest_id);
    }
  });
  //comment post-add loader
  $("body").delegate("#comment_submit", "click", function(e) {
    //test if this event is entered# alert("enter was pressed");
    $(".comments_content_container").append("<p><img src='/images/loader.gif'/> Adding comment...</p>");
    $(".comments_form_container").hide();
  });
  // comment auto-resize, bound to the additional js file, 

//interest browser back - nav
$("body").delegate(".interest_browser_switch", "click", function() {
  $(this).remove();
  $("#interestbrowser").show();
});

$("body").delegate(".interest_browser_switch", "mouseover", function() {
  $(this).css("background-color","#d1ffc0");
});
$("body").delegate(".interest_browser_switch", "mouseout", function() {
  $(this).css("background-color","#d8d8d8");
});


  //interest preview effects
    $(".preview_slot").live({
      mouseenter: function () {
	$(".preview_slot").css("background-color","transparent");
        $(this).css("background-color","#E6E6E6");
        $(".interest_operators",this).show();
      },
      mouseleave: function () {
        $(".interest_operators").fadeOut();
      },
      click: function () {
        var identificator = $(this).attr("data-id");
        $(this).css("background-color","transparent");
        $.getScript("/interests/"+identificator);
      }

    });
    //operators for mind selection on message sending
    //the first is to change background and add to the selected array
    $("body").delegate(".mind_selection","mouseover", function(){
      $(this).css("cursor","hand");
    });
    $("body").delegate(".mind_selection.mind_unselected","click", function() {
      $(this).removeClass("mind_unselected");
      $(this).addClass("mind_selected");
      var identificator = $(this).attr("data_id");
      $(".memory_contribution").append("<input name='selected_minds[]' value="+identificator+" type='hidden' id='trustor"+identificator+"' />");
    });
    //the second is to change background and remove from selected array
    $("body").delegate(".mind_selection.mind_selected","click", function() {
      $(this).removeClass("mind_selected");
      $(this).addClass("mind_unselected");
      var identificator = $(this).attr("data_id");
      $("#trustor"+identificator).remove();
    });

    //handle the trustor load for message creation
    $("body").delegate("#beads_posts_interest_id", "change", function(){
       var interest_id = $(this).val();
       $(".memory_contribution").html("<p id='trustorload'><img src='/images/loader.gif'/> Loading trustors...</p>");
       $.getScript("/posts/new?interest_id="+interest_id);
    });

    //handle effect after post submission
    $("#post_submit").click(function() {
       $(".content_create_message").append("<p id='postsubmission'><img src='/images/loader.gif'/> Adding message...</p>");
       $(this).hide();
    });
    //generic operator preview
    //$.getScript("/javascripts/preview_ops.js");
    //generic operator preview
    $("body").delegate(".item_with_operators","hover",function() {
      $(".operators").hide();
      var identificator = $(this).attr("data-id");
      $("#operators_" + identificator).show();
    });
    $("#flash_notice, #flash_error, .flash_dynamic, #flash_alert").fadeOut(7000);
//end of document load
});
