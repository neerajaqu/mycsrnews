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
		$(this).next().html("<img src=\"/images/btn-comment-spinner.gif\" />");
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
  	var list = $('.list_stories ul', $(this).parents().filter('.panel_1'));
  	$.post(url, $(this).serialize(), function(data) {
  		$(list).quicksand( $(data).find('li'), {adjustHeight: false} );
  		rebuild_facebook_dom();
    });
  });

  $('.flag-form').change(function() {
    $('.flag-form').submit();
  });

  $('.flag-form').submit(function(event) {
  	event.preventDefault();
  	$(this).parent().parent().toggle();

  	var url = change_url_format($(this).attr('action'));
  	var list = $('.list_stories ul', $(this).parents().filter('.panel_1'));
  	$.post(url, $(this).serialize(), function(data) {
  		$(list).quicksand( $(data).find('li'), {adjustHeight: false} );
  		rebuild_facebook_dom();
    });
  });

	$('.voteLink, .voteUp, .voteDown, .thumb-up, .thumb-down').click(function(event) {
		event.preventDefault();
		var span = $(this).parent();
		$(this).parent().html("<img src=\"/images/btn-comment-spinner.gif\" />");
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
		$(this).parent().html("<img src=\"/images/spinner.gif\" />");
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
            $("#image_selector").jcarousel({
              initCallback: set_carousel
            });

            my_carousel.size(data.images.length);
            jQuery.each(data.images, function(i, url) {
              my_carousel.add(i+1, '<img src="'+url+'" width="75" height="75" />');
            });
            my_carousel.reload();

            $('.jcarousel-item:first').addClass('jcarousel-selected');
            $('#content_images_attributes_0_remote_image_url').val(data.images[0]);
            $('.jcarousel-item').click(function() {
            	$('.jcarousel-item.jcarousel-selected').removeClass('jcarousel-selected');
            	$(this).addClass('jcarousel-selected');
            	//$('#content_image_url').val($(this).find('img:first').attr('src'));
            	$('#content_images_attributes_0_remote_image_url').val($(this).find('img:first').attr('src'));
            });
            $('#images').show();
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
