/*
 * TODO:: BUILD LIBRARY
 * -selectors
 * -ajax
 * -utility functions
 * -etc
 * -add base site url to javascript
 */
$(function() {

  $('.hide').hide();
  $('.unhide').show().removeClass('hidden');

  function change_url_format(url, format) {
    url = getRelURL(url);
    if (typeof(format) == 'undefined') { format = '.fbjs'; }

    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.fbml') {
      url = url.substring(0, url.length - 5) + format;
    } else if (url.match(/like.fbml/)) {
      url = url.replace(/like.fbml/, 'like.fbjs');
    } else {
      url = url + format;
    }

    return url;
  }

  function getRelURL(url) {
      return SITE_URL + url.replace(/^(?:http:\/\/apps.facebook.com)?\/[^\/]+(.*)/, "$1");
  }

  $('a.voteLink, a.voteUp, a.voteDown').click(function(event) {
    event.preventDefault();
    var url = change_url_format($(this).href());
    var span = $(this).parent();
    span.html("<img src=\""+SITE_URL+"/images/spinner.gif\" />");
    $.post(url, {}, { success: function(data) {
      if (typeof(data.error) != "undefined") {
        if (data.status == 401) {
          new Dialog().showMessage('Registration Required', dialog_register, 'Cancel');
        }
      } else {
        span.html("<span>"+data.msg+"</span>");
      }
    }}, "JSON");
  });

  $('.account-toggle').click(function(event) {
  	event.preventDefault();  	
	if ($(this).next().children().length==0) {
		$(this).next().html("<img style=\"float:right;\" src=\""+SITE_URL+"/images/spinner.gif\" />");
		$(this).next().show(); 
		$.update($(this).next(), SITE_URL+'/account_menu.fbjs');
		$(this).next().show(); // force show on load
	} else {
		  	$(this).next().toggle(); // if already loaded, show immediately
	}
  });

  $('.update-bio').click(function(event) {
    event.preventDefault();
  	$('.current-bio').toggle();
    $(this).parent().next().toggle();
  });

  $('.refine-toggle, .flag-toggle').click(function(event) {
    event.preventDefault();
    $(this).next().toggle();
  });

  $('.refine-form').submit(function(event) {
    event.preventDefault();
    $(this).parent().parent().toggle();
    var url = change_url_format($(this).action());
    var panel = $(this).parents().filter('.panel_1');
    panel = $(panel.nodes[0]);
    var list = panel.children().filter('.list_stories').children().filter('ul');
    $.update(list, url, $(this).serialize());
  });

  $('a.toggle-form').click(function(event) {
  	event.preventDefault();
  	$(this).parent().next().toggle();
  });

  $('.flag-form').change(function() {
    $('.flag-form').submit();
  });

  $('.flag-form').submit(function(event) {
    event.preventDefault();
    $(this).parent().parent().toggle();
    var url = change_url_format($(this).action());
    var panel = $(this).parents().filter('.panel_1');
    panel = $(panel.nodes[0]);
    var list = panel.children().filter('.list_stories').children().filter('ul');
    $.update(list, url, $(this).serialize());
  });

  $('form#new_question #question_question').focus(function(event) {
  	$('.fullQuestionForm').show();
  });

  $('.answer_link').click(function(event) {
  	event.preventDefault();
  	$('#answerForm').toggle();
  });
  $('#answersList #commentThread, #answersList #postComment').hide();
  $('.answer_comments_link').click(function(event) {
  	event.preventDefault();
  	var answer = $(this).parents().filter('.answer');
  	answer = $(answer.nodes[0]);
    answer.children().filter('#commentThread, #postComment').toggle();
  });

});
