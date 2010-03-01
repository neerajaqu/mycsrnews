/*
 * TODO:: BUILD LIBRARY
 * -selectors
 * -ajax
 * -utility functions
 * -etc
 * -add base site url to javascript
 */
$(function() {
  function change_url_format(url, format) {
    url = getRelURL(url);
    if (typeof(format) == 'undefined') { format = '.fbjs'; }

    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.fbml') {
      url = url.substring(0, url.length - 5) + format;
    } else {
      url = url + format;
    }

    return url;
  }

  function getRelURL(url) {
      return SITE_URL + url.replace(/^(?:http:\/\/apps.facebook.com)?\/[^\/]+(.*)/, "$1");
  }

  $('a.voteLink').click(function(event) {
    event.preventDefault();
    var url = change_url_format($(this).href());
    var span = $(this).parent();
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

  $('.refine-toggle').click(function(event) {
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
});

