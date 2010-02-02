These instructions have proven useful for setting up on OS X Snow Leopard
-----------------------------------------------------------------------------
* Create a Facebook application for testing
	e.g. http://facebook.com/developers

* Set up Local Facebook Development
Register and set up a dynamic DNS e.g. dyndns.com to point to your development box
 for more info see http://www.uebersoftware.com/2009/07/fb-series-locally-debug-your-php-facebook-app/

* Set up your source code tree 
e.g. git clone git@github.com:newscloud/N2.git

* duplicate facebooker.yml.sample to facebooker.yml
add a facebook app to 
configure facebooker.yml

duplicate database.yml.sample to database.yml
edit database.yml
create database rsmt_development

cd /usr/local/mysql/bin
sudo ./mysql -uroot -p
rake n2:db:convert_and_create_database

ruby script/server -p 8858 
http://localhost:8858

Delete socket: from database.yml

Edit ~/.bashrc or ~/.bash_profile, look for the export PATH="………" line, and the very end change it so you have /usr/local/mysql/bin on it.

If you don't have a path variable set, then you want to add:

export PATH=$PATH:/usr/local/mysql/bin

Then you need to reload your bashrc file with: source ~/.bashrc and you should be good to go.
