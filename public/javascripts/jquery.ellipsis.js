// Thanks to http://stackoverflow.com/questions/536814/insert-ellipsis-into-html-tag-if-content-too-wide/2859345#2859345
// Modified to work across a set and looks for parent element classes of the form ellipsis_(?:title|caption)_([0-9])
// and sets the height as a ratio of that
(function($) {
  $.fn.ellipsis = function() {
    return this.each(function() {
      var element = $(this);
      var parentSpan = element.parent();
      var match = maxHeight = null;
      var captionHeight = 25;
      var titleHeight = 30;

      if ( (match = parentSpan.attr('class').match(/ellipsis_title_([0-9])/)) ) {
        maxHeight = titleHeight * parseInt(match[1]);
      } else if ( (match = parentSpan.attr('class').match(/ellipsis_caption_([0-9])/)) ) {
        maxHeight = captionHeight * parseInt(match[1]);
      } else {
        maxHeight = 50;
      }

      var text = element.text();
      var characters = text.length;
      var step = text.length / 2;
      var newText = text;
      var allowedEndings = [' ', ',', '.', '!', '?'];

      while (step > 0) {
        element.html(newText);
        if (element.outerHeight() <= maxHeight) {
          if (text.length == newText.length) {
            step = 0;
          } else {
            characters += step;
            newText = text.substring(0, characters);
          }
        } else {
          characters -= step;
          newText = newText.substring(0, characters);
        }
        step = parseInt(step / 2);
      }
      if (text.length > newText.length) {
        element.html(newText + "...");
        if (newText.length >= 1) {
          while ( (element.outerHeight() > maxHeight || newText.slice(-1).match(/[^\s,.!?]/)) && newText.length >= 1) {
            newText = newText.substring(0, newText.length - 1);
            element.html(newText + "...");
          }
        }
      }
    });

  };
})(jQuery);
