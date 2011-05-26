Installing on Ubuntu 10.04 LTS
======================================================

This guide will bootstrap a production newscloud install on Ubuntu 10.04. We have tested this configuration specifically for a 1 GB Rackspace cloud-based server, which costs about $45 per month. 

We're not affiliated with rackspace in any way, we just see it as a good, affordable hosting choice for organizations interested in NewsCloud.

Part One: Prerequisites
=======================

You may want to review our installation support page which lists a configuration checklist and detailed explanations of what's required to run a NewsCloud community. See [Installing NewsCloud](http://support.newscloud.com/kb/installing-newscloud)

Create Rackspace Cloud Server with 1024 megs
----------------------------------------------------------------------

Visit [Rackspace](http://www.rackspacecloud.com/2352.html) and sign up for a 1024 mb cloud server.

Domain Name Configuration
-------------------------

Use your DNS provider to point your domain name at the IP address of the rackspace server. Need more information? Visit [How to register a domain for your NewsCloud site](http://support.newscloud.com/kb/installing-newscloud/how-to-register-a-domain-for-your-newscloud-site) and [How to map your domain's DNS for Facebook Connect](http://support.newscloud.com/kb/installing-newscloud/how-to-map-your-domains-dns-for-facebook-connect)

Register your facebook application
----------------------------------

You will need to have a facebook developer application, either:

  * Create a [new application](http://www.facebook.com/developers/createapp.php)
  * Use an [existing application](http://www.facebook.com/developers/)

NOTE:

You can see a bit more detail and screenshots of example Facebook configurations on our support page. [How to register your application with Facebook](http://support.newscloud.com/kb/installing-newscloud/how-to-register-your-application-with-facebook)

  * You **must** set your canvas url to end in /iframe/, ie http://mysite.com/iframe/
  * However, when you set your config files you only want to use http://mysite.com
  * This is used internally to allow the use of a facebook canvas app and an external web pages
  * Other settings of note are:
    * Canvas Type = Iframe
    * Iframe Size = Auto-resize

Part Two: Bootstrap Your New Server
===================================

Setup a deploy user
-------------------

By default rackspace provides a root account on the ubuntu server, so we will add a deploy
user and give that user sudo access by adding deploy to the sudo group.

	$ ssh root@mysite.com

	# adduser deploy
	# adduser deploy sudo


Create the /data directory for deploying your app to /data/sites/mysite
-----------------------------------------------------------------------
	
	# mkdir -p /data/sites
	# chown -R deploy:deploy /data
	# chmod -R 755 /data

	
Now switch to the deploy user and setup your ssh key
----------------------------------------------------
	
	# su deploy
	$ cd $HOME
	$ mkdir .ssh
	$ touch .ssh/authorized_keys
	$ vi .ssh/authorized_keys

Paste your public ssh key from your development box in .ssh/authorized_keys.

Update Your System
------------------
If necessary, update your system:

	$ sudo apt-get update

Base Utilities
--------------

Replace vim-nox with your editor of choice.

	$ sudo apt-get install git-core vim-nox


Base Ruby Dependencies
----------------------

Get ruby up and running

	$ sudo apt-get install ruby build-essential libopenssl-ruby ruby1.8-dev irb rubygems

Add rubygems executables to your path

	$ export PATH=/var/lib/gems/1.8/bin:$PATH

Update rubygems

	$ sudo gem install rubygems-update
	$ sudo `which update_rubygems`


Install MySQL
-------------

Install mysql

	$ sudo apt-get install mysql-server mysql-client libmysql-ruby libmysqlclient-dev

Create a newscloud database and user

	$ mysql -u root -p

	create database mysite_production;
	grant ALL on mysite_production.* to mysite_db_user@localhost identified by 'SOME SECURE PASSWORD';


Install Redis 2
---------------

First grab Redis and build it

	$ cd /tmp
	$ wget http://redis.googlecode.com/files/redis-2.2.8.tar.gz
	$ tar zxvf redis-2.2.8.tar.gz
	$ cd redis-2.2.8
	$ make
	$ sudo make install

Add a Redis user

	$ sudo useradd redis

Grab our prebuilt config files and move them in place

	$ wget --no-check-certificate https://github.com/newscloud/n2/raw/release3_2/doc/redis-server
	$ wget --no-check-certificate https://github.com/newscloud/n2/raw/release3_2/doc/redis.conf
	$ sudo mv redis-server /etc/init.d/redis-server
	$ sudo mv redis.conf /etc/redis.confg
	$ sudo chmod +x /etc/init.d/redis-server

Create the requisite directories for Redis

	$ sudo mkdir -p /var/lib/redis
	$ sudo mkdir -p /var/log/redis
	$ sudo chown redis:redis /var/lib/redis
	$ sudo chown redis:redis /var/log/redis

Update the init script with default settings and start Redis

	$ sudo update-rc.d redis-server defaults
	$ sudo /etc/init.d/redis-server start

Verify Redis is up and running

	$ redis-cli info

Install Miscellaneous Dependencies
----------------------------------

Install nokogiri dependencies

	$ sudo apt-get install libxml2 libxml2-dev libxslt1-dev

Install curl dependencies

	$ sudo apt-get install curl libcurl3 libcurl3-gnutls libcurl4-openssl-dev

Install imagemagick

	$ sudo apt-get install imagemagick

Install nginx

	$ sudo apt-get install nginx

Required rubygems
	
	$ sudo gem install bundler
	$ sudo gem install god


Part Three:: Deploying newscloud from your dev machine
======================================================

Now that we have the base server up and running, we can use capistrano to do the heavy lifting.

**NOTE**: These commands will now be run from your local dev machine.

You will need to have capistrano and the capistrano multistage extension installed.

	$ gem install capistrano capistrano-ext

First grab newscloud (on your local machine)
--------------------------------------------

	$ git clone git://github.com/newscloud/n2.git
	$ cd n2
	$ git checkout --track -b release3_2 origin/release3_2

Capistrano Steps
----------------

Run the capistrano configuration wizard. This will ask you for your domain name
as well your as facebook and database settings, so have those at hand.

	$ cap config:wizard

Lets check and make sure everything is setup properly.
Assuming your application name is 'mysite', run the command:

	$ cap mysite deploy:check

If there aren't any errors in deploy:check, you're ready to run the setup task.

	$ cap mysite deploy:setup

If you're getting any errors, make sure you're running cap with your site name, ie:

	$ cap mysite deploy:setup

and not

	$ cap deploy:setup

And finally we're ready to get everything up and running. This will bootstrap
the full newscloud application, installing all the appropriate gems, create the
database and populate it with the initial data, so grab a cup of coffee or a
snack as this will take some time to run.

	$ cap deploy:cold



Once this has finished you should be up and running. Visit http://mysite.com
to see your newscloud application

Make sure and head to http://mysite.com/admin to add yourself as an admin user
and configure the application. Enjoy!
