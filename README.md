Welcome to the Newscloud framework
==================================

NewsCloud is an open-sourceFacebook application that brings the power of community to news organizations. It is powered in part by technology funded by the John S. and James L. Knight Foundation.


Getting Started
---------------

Clone this application to your machine and checkout release 2

        git clone git://github.com/newscloud/n2.git
        git checkout --track -b release2 origin/release2

Alternatively, download release 2 directly [http://github.com/newscloud/n2/archives/v2.0_stable](https://github.com/newscloud/n2/tree/release2)

Register a facebook application
-------------------------------

  * Visit [http://www.facebook.com/developers/](http://www.facebook.com/developers/) and register your application
  * You **must** set your canvas url to end in /iframe/, ie http://my.site.com/iframe/
  * However, when you set your config files you only want to use http://my.site.com
  * This is used internally to allow the use of a facebook canvas app and an external web pages
  * Other settings of note are:
    * Canvas Type = Iframe
	* Iframe Size = Auto-resize

Install required software
-------------------------

  * MySQL
  * Memcached
  * Redis 2.x

We currently require the use of Memcached and Redis for caching and background job processing respectively.  We are in the process of fully converting over to Redis, but for the time being both are required.

Memcached is only required in production and can be disabled in config/environments/production.rb
Redis/Resque are required in both development and production environments as Rails does not have a generic job queue hook.

Setup your config files
-----------------------

The primary(required) config files are:

  * application_settings.yml -- misc config options
  * database.yml
  * facebooker.yml -- remember to set callback_url to your base site, ie http://my.site.com
  * compass.rb -- need to set http_images_path to your absolute web address
  * locales.yml -- select the languagues you will be using
  * menu.yml -- configure what menu items you want to appear in your application
  * resque.yml -- where to find your redis server

The optional config files for advanced settings are:

  * newrelic.yml for use with the [New Relic](http://newrelic.com/) monitoring (Note: we are not affiliated, we just like their application)
  * smtp.yml for outgoing mail
  * application.god for use with the [God monitoring system](http://god.rubyforge.org/)
  * unicorn.conf.rb
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

As long as there are no existing admin users, you can use a default login to get into the admin interface. Register as a user and make sure to set yourself as an admin immediately.
Default login for http://my.site.com/admin :

       login: admin
	   password: n2adminpassword

Once there, goto the Members -> Users tab and edit your user account to make you an admin.

Next Steps
----------

Now that you are an admin user, you can configure your home page by going to the tab Front Page -> Build Layout -> Choose Widgets
For more information about configuring you home page, read our [Widget Builder Guide](http://support.newscloud.com/faqs/managing-your-application/using-the-new-masonry-layout-and-widget-builder)

We have a wide array of documentation and articles located at http://support.newscloud.com/

Some useful starting points are:

  * [Configuring Your Application](http://support.newscloud.com/faqs/configuring-your-application)
  * [Managing Your Application](http://support.newscloud.com/faqs/managing-your-application)
  * [Using your Facebook Application](http://support.newscloud.com/faqs/using-your-facebook-application)

Developers
----------

There is always more to do in the software world, and we need your help. Grab a fork and hack away! If you're interested in discussiong the application further, please get in touch with us.
