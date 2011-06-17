Newscloud Cookbooks
===================

This cookbooks directory is primarily a fork of the base opcode cookbook repo.
Nearly everything in here is vanilaa, aside from a few exceptions:

  * Deleted openldap because it was causing issues
  * Forked the xml cookbook to libxml as it was not adequate for nokogiri.
  * Custom redis2 cookbook for redis 2.x from source instead of ubuntu 1.x
  * updated iptables recipe
  * newscloud_deps cookbook for curl and ssl
  * newscloud_database for creating a rails database
