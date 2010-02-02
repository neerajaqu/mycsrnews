/*
 * TODO:: BUILD LIBRARY
 * -selectors
 * -ajax
 * -utility functions
 * -etc
 * -add base site url to javascript
 */
function Each(array, block) {
	for (var i = 0, l = array.length; i < l; i++) {
		block(array[i]);
  }
}

function getRelURL(url) {
	return SITE_URL + url.replace(/^http:\/\/apps.facebook.com\/[^\/]+(.*)/, "$1");
}

var doc = document.getElementById("appFrame");
var anchors = doc.getElementsByTagName("a");

Each(anchors, function(anchor) {
	if (anchor.getClassName() == 'voteLink') {
    var url = getRelURL(anchor.getHref());
    url = url.replace(/\?return_to=.*$/, '');
    if (url.substring(url.length - 5) == '.fbml') {
      url = url.substring(0, url.length - 5) + ".fbjs";
    } else {
      url = url + ".fbjs";
    }
    var span = anchor.getParentNode();
	  anchor.addEventListener('click', function(event) {
	  	event.preventDefault();
	  	var ajax = new Ajax();
	  	ajax.responseType = Ajax.JSON;
	  	ajax.requireLogin = true;
	  	ajax.ondone = function(data) {
	  		if (typeof(data.error) != "undefined") {
	  			if (data.status == 401) {
      	    new Dialog().showMessage('Registration Required', dialog_register, 'Cancel');
          }
        } else {
	  		  span.setInnerXHTML("<span>"+data.msg+"</span>");
        }
      }
      ajax.onerror = function(data) {
      	span.setInnerXHTML(data.msg);
      }
	  	ajax.post(url);
    });
  }
});
