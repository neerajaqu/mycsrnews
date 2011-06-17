# Cookbook template based on Opscode xml cookbook
maintainer       "Russell Branca (Newscloud)"
maintainer_email "chewbranca@gmail.com"
license          "Apache 2.0"
description      "Installs misc Newscloud dependencies"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

recipe "newscloud_deps", "Installs misc Newscloud dependencies"

%w{ ubuntu debian }.each do |os|
  supports os
end
