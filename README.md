Welcome to the Newscloud framework
==================================

NewsCloud is an open-source Facebook Connect Website and Facebook Application that brings the power of community to news  organizations. It is powered in part by technology funded by the John S. and James L. Knight Foundation.Funding for our open source development will continue through April 30, 2012.

For a complete feature list of the platform, visit [http://newscloud.net/idLbRa](http://newscloud.net/idLbRa). Follow [@newscloud on Twitter](http://twitter.com/newscloud) for updates.

View the Ubuntu Server 10.04 lts install guide
----------------------------------------------

We now have a full guide for bootstrapping and install newscloud on a minimal Ubuntu Server 10.04 LTS system.

See the guide at [INSTALL-ubuntu.md](https://github.com/newscloud/n2/blob/master/INSTALL-ubuntu.md)

This guide will bootstrap a production newscloud install on Ubuntu 10.04. We have tested this configuration specifically for a 1 GB Rackspace cloud-based server, which costs about $45/mo. 


Getting Started
---------------

Clone this application to your machine and checkout release 3

        git clone git://github.com/newscloud/n2.git
        git checkout --track -b release3_2 origin/release3_2

Alternatively, download release 3 directly [http://github.com/newscloud/n2/archives/v3.2_stable](http://github.com/newscloud/n2/archives/v3.2_stable)

Register a facebook application
-------------------------------

  * Add the Facebook developer application [http://www.facebook.com/developers/](http://www.facebook.com/developers/) and [create a new application](http://www.facebook.com/developers/createapp.php)
  * You **must** set your canvas url to end in /iframe/, ie http://my.site.com/iframe/
  * However, when you set your config files you only want to use http://my.site.com
  * This is used internally to allow the use of a facebook canvas app and an external web pages
  * Other settings of note are:
    * Canvas Type = Iframe
	* Iframe Size = Auto-resize

Install required software
-------------------------

  * MySQL
  * Redis 2.x

We have switched over to using Redis completely, so memcached is no longer required.

Redis is used in production for caching, the development environment does not do any caching.

However, Redis/Resque are required to be installed for development mode as there isn't
a pluggable job system in rails like the caching system.

You do not need to run a resque worker in development, but things will error out if
you do not have an open redis connection.

We currently require MySQL. We are working on removing the dependency on MySQL, but for now
its required. Additional database targets are PostgreSQL and SQLite.

Setup your config files
-----------------------

The primary(required) config files are:

  * database.yml
  * facebooker.yml -- remember to set callback_url to your base site, ie http://my.site.com

The optional config files for advanced settings are:

  * application_settings.yml -- misc config options
  * resque.yml -- where to find your redis server, defaults to localhost:6379
  * newrelic.yml for use with the [New Relic](http://newrelic.com/) monitoring (Note: we are not affiliated, we just like their application)
  * smtp.yml for outgoing mail
  * menu.yml -- configure what menu items you want to appear in your application
  * application.god for use with the [God monitoring system](http://god.rubyforge.org/)
  * unicorn.conf.rb
  * locales.yml -- select the languagues you will be using
  * There are a number of other advanced files in the config directory

We provide .sample files for the majority of these config files to facilitate easy setup.

As mentioned above, when you set your config options, **remember to use** http://my.site.com and **not** http://my.site.com/iframe/

Install dependencies and setup the framework
--------------------------------------------

Now that we got the hard part out of the way, there are just a few commands left to run.

        # Install [Bundler](http://gembundler.com/)
        sudo gem install bundler
        # Install the required gems
        bundle install
        # Run the newscloud setup process, this will create your database along with configuring your application
        rake n2:setup

Post Installation
-----------------

You can now run your application in the typical rails fashion by doing:

       ruby script/server

or by whatever means you normally use.

You must set up an administrator. First, visit your Facebook application or website and register as a user. Then, visit the administration site e.g. http://my.site.com/admin and make yourself an administrator e.g. goto the Members -> Users tab and edit your user account to make you an admin.

Next Steps
----------

Now that you are an admin user, you can configure your home page by going to the tab Front Page -> Build Layout -> Choose Widgets
For more information about configuring you home page, read our [Widget Builder Guide](http://support.newscloud.com/faqs/managing-your-application/using-the-new-masonry-layout-and-widget-builder)

We have a wide array of documentation and articles located at http://support.newscloud.com/

Some useful starting points are:

  * [Community Guide to the NewsCloud Open Source Facebook Platform](http://blog.newscloud.com/community-guide-to-the-newscloud-open-source-facebook-platform.html)
  
  * [Configuring Your Application](http://support.newscloud.com/faqs/configuring-your-application)
  
  * [Managing Your Application](http://support.newscloud.com/faqs/managing-your-application)
  
  * [Using your Facebook Application](http://support.newscloud.com/faqs/using-your-facebook-application)

Developers
----------

There is always more to do in the software world, and we need your help. Grab a fork and hack away! If you're interested in discussing the application further, please get in touch with us.
