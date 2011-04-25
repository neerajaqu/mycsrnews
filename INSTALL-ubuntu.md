Installing on Ubuntu 10.04 LTS Server
=====================================

This guide will bootstrap newscloud from a minimal ubuntu server install.

Base Utilities
--------------

Replace vim-nox with your editor of choice.

	sudo apt-get install ssh git-core vim-nox


Base Ruby Dependencies
----------------------

Get ruby up and running

	sudo apt-get install ruby build-essential libopenssl-ruby ruby1.8-dev irb rubygems

Add rubygems executables to your path

	export PATH=/var/lib/gems/1.8/bin:$PATH

Update rubygems

	sudo gem install rubygems-update
	sudo `which update_rubygems`

Set your rails environment variable if need be
	
	export RAILS_ENV=development


Install MySQL
-------------

Install mysql

	sudo apt-get install mysql-server mysql-client libmysql-ruby libmysqlclient-dev

Create a newscloud database and user

	mysql -u root -p

	create database n2_development;
	grant ALL on n2_development.* to n2db@localhost identified by 'SOME SECURE PASSWORD';


Install Memcached and Redis
---------------------------

	sudo apt-get install memcached libmemcache-client-ruby libmemcached-dev

	sudo apt-get install redis-server

Install Miscellaneous Dependencies
----------------------------------

Install nokogiri dependencies

	sudo apt-get install libxml2 libxml2-dev libxslt1-dev

Install curl dependencies

	sudo apt-get install curl libcurl3 libcurl3-gnutls libcurl4-openssl-dev


Install Newscloud
-----------------

Create a directory for where newscloud and pull from github.
Make Sure to checkout release 3.

	mkdir src
	cd src/
	git clone git://github.com/newscloud/n2.git
	cd n2
	git checkout --track -b release3 origin/release3


Configure your database with the settings you created earlier in mysql.

	cp config/database.yml.sample config/database.yml
	vim config/database.yml

Register a facebook application
-------------------------------

Configure facebooker with the keys from your facebook application
You will need to have a facebook developer application, either:

  * Create a [new application](http://www.facebook.com/developers/createapp.php)
  * Use an [existing application](http://www.facebook.com/developers/)

NOTE::

  * You **must** set your canvas url to end in /iframe/, ie http://my.site.com/iframe/
  * However, when you set your config files you only want to use http://my.site.com
  * This is used internally to allow the use of a facebook canvas app and an external web pages
  * Other settings of note are:
    * Canvas Type = Iframe
	* Iframe Size = Auto-resize

Add your facebook settings to facebooker.yml

	cp config/facebooker.yml.sample config/facebooker.yml
	vim config/facebooker.yml


Install required rubygems
-------------------------

First install the bundler gem

	sudo gem install bundler

Use bundler to install the required gems

	bundle install

Bootstrap the Newscloud System
------------------------------
	bundle exec rake n2:setup

Launch Newscloud
----------------

Start the server

	bundle exec ruby script/server

Start the resque worker and resque scheduler for background and scheduled tasks.

	QUEUE=* bundle exec rake resque:work
	bundle exec rake resque:scheduler INITIALIZER_PATH=config/initializers/resque.rb
