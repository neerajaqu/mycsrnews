// Place your application-specific jQuery JavaScript functions and classes here

function rebuild_facebook_dom() {
  try {
    FB.XFBML.Host.parseDomTree();
  } catch(error) { }
}

// From: http://yehudakatz.com/2009/04/20/evented-programming-with-jquery/
var $$ = function(param) {
  var node = $(param)[0];
  var id = $.data(node);
  $.cache[id] = $.cache[id] || {};
  $.cache[id].node = node;

  return $.cache[id];
};

var $$$ = function(key) {
	$.cache[key] = $.cache[key] || {};

	return $.cache[key];
};

$(function() {
  setTimeout(function() {
		$('.flash').effect('fade', {}, 1000);

  }, 3500);
});
