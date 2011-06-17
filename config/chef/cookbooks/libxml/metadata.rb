#maintainer       "Opscode, Inc."
#maintainer_email "cookbooks@opscode.com"
maintainer       "Russell Branca"
maintainer_email "chewbranca@gmail.com"
license          "Apache 2.0"
description      "Installs xml"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe "libxml", "Installs buntu libxml development packages"

%w{ ubuntu debian }.each do |os|
  supports os
end
