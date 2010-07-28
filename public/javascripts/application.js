// Place your application-specific jQuery JavaScript functions and classes here

function rebuild_facebook_dom() {
  try {
    FB.XFBML.Host.parseDomTree();
  } catch(error) { }
}

$(function() {
  $('.hide').hide();
  $('.unhide').show().removeClass('hidden');

  setTimeout(function() {
		$('.flash').effect('shake');
		$('.flash').hide('puff', {}, 'slow');
  }, 3500);

  function dialog_response(title, message) {
      $("<p>"+message+"</p>").dialog({
          title: title,
          modal: true
      });
  }

  function change_url_format(url, format) {
  	if (typeof(format) == 'undefined') { format = '.json'; }

    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.html') {
      url = url.substring(0, url.length - 5) + format;
    } else {
      url = url + format;
    }

    return url;
  }

  $('.account-toggle').click(function(event) {
  	event.preventDefault();
	if ($(this).next().children().length==0) {
		$(this).next().html("<img src=\"/images/default/spinner-tiny.gif\" />");
  	$(this).next().toggle(); // after spinner appears, toggle it
 		$(this).next().load('/account_menu.js', function() {
  			rebuild_facebook_dom();
		});
	} else {
		  	$(this).next().toggle(); // toggle menu since already loaded
	}
  });

	$('.import-events-toggle').click(function(event) {
		event.preventDefault();
		$('#new_event').toggle();
		$('#import-events').toggle();
	}	
	);
	
  $('.update-bio').click(function(event) {
  	event.preventDefault();
  	$('.current-bio').toggle();
  	$(this).parent().next().toggle();
  });

  $('form#new_question #question_question').focus(function(event) {
  	$('.fullQuestionForm').show();
  });

  $('.refine-toggle, .flag-toggle').click(function(event) {
  	event.preventDefault();
  	$(this).next().toggle();
  });

  $('.refine-form').submit(function(event) {
  	event.preventDefault();
  	$(this).parent().parent().toggle();

  	var url = change_url_format($(this).attr('action'));
  	var list = $('.list_items ul', $(this).parents().filter('.panel_1'));
  	$.post(url, $(this).serialize(), function(data) {
  		$(list).quicksand( $(data).find('li'), {adjustHeight: false} );
  		rebuild_facebook_dom();
    });
  });

  $('.flag-form').change(function(event) {
		event.preventDefault();
		var flag_form = $(this);
		var flag_parent = flag_form.parent().parent().parent();
    if ( $('[name=flag_type]', this).val() != 'choose_flag') {
		  $(this).parent().html("<img src=\"/images/default/spinner-tiny.gif\" />");
      var url = change_url_format(flag_form.attr('action'));
      $.post(url, flag_form.serialize(), function(data) {
				flag_parent.html('<span class="flag-toggle btnComment">'+data.msg+'</span>').fadeIn("normal");
			});
    } 
  });

	$('.voteLink, .voteUp, .voteDown, .thumb-up, .thumb-down').click(function(event) {
		event.preventDefault();
		var span = $(this).parent();
		$(this).parent().html("<img src=\"/images/default/spinner-tiny.gif\" />");
		var url = $(this).attr("href");
    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.html') {
      url = url.substring(0, url.length - 5) + ".json";
    } else if (url.match(/like.html/)) {
      url = url.replace(/like.html/, 'like.json');
    } else {
      url = url + ".json";
    }

		$.ajax({
			type: "POST",
			url: url,
			// Yet another chrome hack
			// chrome sends this xml if both contentType and data are not set
			// and as a result rails flips out
			contentType: 'application/json',
			data: "foo", // data has to be set to explicitly set the content type
			dataType: "json",
			success: function(data, status) {
				span.fadeOut("normal", function() {
				  span.html(data.msg).fadeIn("normal");
        });
      },
      error: function(xhr, status, errorThrown) {
      	var result = $.parseJSON(xhr.responseText);
      	if (xhr.status == 401) {
      	  dialog_response(result.error, result.dialog);
          span.fadeOut("normal", function() {
            span.html(data.msg).fadeIn("normal");
          });
        }
      }
    });
  });

	$('.quick_post').click(function(event) {
		event.preventDefault();
		var span = $(this).parent();
    var $li_parent = $(this).parents().filter('li').first();
		$(this).parent().html("<img src=\"/images/default/spinner.gif\" />");
		var url = $(this).attr("href");
    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.html') {
      url = url.substring(0, url.length - 5) + ".json";
    } else if (url.match(/quick_post.html/)) {
      url = url.replace(/quick_post.html/, 'quick_post.json');
    } else {
      url = url + ".json";
    }

		$.ajax({
			type: "POST",
			url: url,
			// Yet another chrome hack
			// chrome sends this xml if both contentType and data are not set
			// and as a result rails flips out
			contentType: 'application/json',
			data: "foo", // data has to be set to explicitly set the content type
			dataType: "json",
			success: function(data, status) {
				span.fadeOut("normal", function() {
				  span.html(data.msg).fadeIn("normal");
        });
        setTimeout(function() {
          $li_parent.effect('highlight', {color: 'green'}, 2000);
          $li_parent.hide('fold', {}, 'slow');
        }, 1500);
      },
      error: function(xhr, status, errorThrown) {
      	var result = $.parseJSON(xhr.responseText);
      	if (xhr.status == 401) {
      	  dialog_response(result.error, result.dialog);
          span.fadeOut("normal", function() {
            span.html(data.msg).fadeIn("normal");
          });
        } else if (xhr.status == 409) {
          span.fadeOut("normal", function() {
            span.html(result.error).fadeIn("normal");
          });
          setTimeout(function() {
            $li_parent.effect('highlight', {color: 'red'}, 3000);
          }, 1500);
        }
      }
    });
  });

  $('a.toggle-form').click(function(event) {
  	event.preventDefault();
  	$(this).parent().next().toggle();
  });

  $('.answer_link').click(function(event) {
  	event.preventDefault();
  	$('#answerForm').toggle();
  });
  $('.commentThread, .postComment', $('#answersList')).hide();
  $('.answer_comments_link').click(function(event) {
  	event.preventDefault();
    $('.commentThread, .postComment', $(this).parents().filter('.answer')).toggle();
  });

  /* Predictions */

  $('.prediction-question-form').change(function(event) {
  	event.preventDefault();
  	var prediction_question_form = $(this);
    //var $li_parent = $(this).parents().filter('li').first();
  	var span = $(this).parent();
    if ( $('[name=guess]', this).val() != 'predictions.select_guess') {
  	  $(this).parent().html("<img src=\"/images/default/spinner-tiny.gif\" />");
      var url = change_url_format(prediction_question_form.attr('action'));
      $.post(url, prediction_question_form.serialize(), function(data) {
			  span.html(data.msg);
  		});
    } 
  });
  

});


/* 
 * Post Story Functionality
 */
$(function() {
	var my_carousel = null;
	function set_carousel(carousel) {
		my_carousel = carousel;
  }

	$('form.post_story #content_url').blur(function() {
		if ($(this).val() != '') {
      $(this).addClass('process');
      $('#content_title').addClass('process');
      $.post("/stories/parse_page", 
        {url: $(this).val()},
        function(data, status) {
          if ($('#content_title').val() == '') {
            $('#content_title').val(data.title);
          }
          if (data.description) {
            if ($('#content_caption').val() == '') {
              $('#content_caption').val(data.description);
            }
          }
          if (data.images.length > 0) {
            // Hack to make this work in chrome..
            // can't use your typical itemLoadCallback
						$("#scrollbox").show();

						$(".scrollable").scrollable();
						
						var api = $(".scrollable").data("scrollable");
            jQuery.each(data.images, function(i, url) {
              api.addItem('<img src="'+url+'" width="75" height="75" />');
            });
						$(".items img").click(function() {
							if ($(this).hasClass("selected-image"))
							{
								$(this).removeClass('selected-image');
							}
							else {
        	    	$(this).addClass('selected-image');
								var in_use = false;
								var current_src = $(this).attr('src');
								$('.image-url-input').each( function(i, input){
									if ($(input).val() == current_src)
									{
										in_use = true;
									}
								});
								if (!in_use){
									$('#add_image').click();
	            		$('.image-url-input').last().val($(this).attr('src'));

									$('.image-url-input').last().parent().next().remove();
									$('.image-url-input').last().next().remove();
									$('.image-url-input').last().after($('.delete_image').last());
								}
							}
						});
          }
          $('#content_url').removeClass('process');
          $('#content_title').removeClass('process');
        },
        "json");
    }
  });

  if ($('form.post_story #content_url').val() != '') {
    $('#content_url').trigger('blur');
  }

});

/** IMAGE VIEWER **/
$(function() {
	$("#thumbnails").scrollable({size: 3, clickable: false}).find("img").each(function(index) {

			// thumbnail images trigger the overlay
			$(this).overlay({

				effect: 'apple',
				target: '#overlay',
				mask: { maskId: 'mask' },
    		onBeforeLoad: function() {

    			// grab wrapper element inside content
    			var wrap = this.getOverlay().find(".contentWrap");

    			// load the page specified in the trigger
    			wrap.html("<img src=\""+this.getTrigger().attr("src")+"\"\/>");
  			
  			
    		}
				// when box is opened, scroll to correct position (in 0 seconds)
				// onLoad: function() {
				// 	$("#images").data("scrollable").seekTo(index, 0);
				// }
			});
		});
	$("#images").scrollable();
});

