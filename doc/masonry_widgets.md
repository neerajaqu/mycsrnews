Newscloud's New Widget Builder Using Masonry
============================================

We are now using the jQuery
[Masonry](http://desandro.com/resources/jquery-masonry/) plugin for layouts on
the homepage. Why Masonry? Because as our widgets become more diverse in size
and dimension, so do the range of possibilities of potential layouts as well as
the inherent complexities of making it all work well together.  Masonry allows
us to have more flexible control over the entire look and feel of a page,
removing the requirements of having a specific sidebar location or even a
sidebar at all, and does a great job of ensuring the best possible spacing for
your layout. Masonry describes itself as:

> Masonry is a layout plugin for jQuery. Think of it as the flip side of CSS
> floats. Whereas floating arranges elements horizontally then vertically,
> Masonry arranges elements vertically then horizontally according to a grid.
> The result minimizes vertical gaps between elements of varying height, just
> like a mason fitting stones in a wall.

We have been using CSS floats to previously accomplish the homepage layout.
It has been troublesome to accomodate the variety of widgets we have while
ensuring a consistent result across all browsers. Another issue is the current
design of main column and right sidebar. We want you to be able to customize
your page to look and feel how you want, this is something masonry will help
provide.

Customization Woes
------------------

One of the biggest issues we have all experienced with the existing layout
system is how tough it is to use the current widget builder. What started out
as a simple and friendly interface for dragging your widgets where you would
like them to appear and then seeing the end result, quickly became unwieldly as
the number of widgets increased. Originally we also distinguished between
widgets that should go in the main column, and widgets that should go in the
sidebar. We gradually dropped that requirement as it became apparent having
the ability to place smaller widgets in the main content area was a good thing.
Masonry takes this a step further by allowing you to place widgets anywhere in
the page you want.

Our new widget builder interface is greatly simplified in two ways. First off,
the list of widgets is now broken up into tabs containing related widgets to
simplify finding the widget you want without having to scroll down the page.
Second, instead of the giant main and sidebar boxes that would quickly fill
up the entire page with a few widgets, we just have a single drop box that
contains a list of the names of your selected widgets. This simplifies the
interface by keeping it clean and small. We only display the names of widgets
now to facilitate easy selection and reordering. To see what your homepage
will look like, there is a preview button that will load another page
showing you the resulting page layout. We feel that this tradeoff of
previewing your layout in a second page greatly reduces the complexity of
making everything work in a single page resulting in a better experience.

A Different Approach to Layouts
-------------------------------

The biggest conceptual difference with using Masonry is understanding how the
home page is positioned. Before, you placed widgets in the main or sidebar
column and then selected whether the main widgets should be on the left or 
right. Now, the only thing you need to specify is the order of widgets.
The home page is still divided into 3 columns, but Masonry figures out where
to place your widgets by going down the list in the order you specified.
What happens is each widget gets appended to the page in order starting from the
top left and going to the right and down like reading a book. Think of it like
making a scrap book with a bunch of different photos. Some photos are wide,
some are tall, some big, some small, but making them all fit together on a page
while making as efficient use of space as possible is tricky. That's where
Masonry comes in. You tell it what photos to put in the page, and then it
handles properly arranging them for you. You exchange a degree of accuracy in
positioning for a substantial increase in the ability to cleanly and
efficiently layout your photos. The end result is an impressive ability to
make dynamic and exciting layouts.

How to Build Your Layout?
-------------------------

To use this just goto the widget builder in the admin interface like you 
normally would. There you will see the new list of widgets divided up into
tabs for simplicity. You can select any combination of widgets from the
different tabs to drag into the widget drop box area. Once in there, you
can rearrange the widgets as you see fit, or to remove a widget, drag it back
onto the highlighted tabs box and drop it. Once you have selected your desired
widgets, you may hit the preview button to see what it looks like.

When you hit the preview button, it will open a new tab or window loading a
preview page in the application with your new layouts. My recommendation is to
keep both of these windows open. Preview your widgets, then go back to the
admin page and make any changes you want, then click preview again which will
refresh the preview window you left open. This way its simple to go back and
forth between the two until you find a layout you like. You can rearrange and
preview the widgets as much as you like without affecting your actual home
page. Once you are satisfied with your new layout, click the save button and
then visit your new home page!
