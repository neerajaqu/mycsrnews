#
# Borrowed from https://github.com/engineyard/eycap
#
# Copyright (c) 2008-2009 Engine Yard
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Capistrano::Configuration.instance(:must_exist).load do

  namespace :ssl do    
    desc "create csr and key for ssl certificates"
    task :create, :roles => :app, :except => {:no_release => true} do
      sudo "mkdir -p /data/ssl/"
      set(:length) { Capistrano::CLI.ui.ask("key length (1024 or 2048): ") }
      set(:country) { Capistrano::CLI.ui.ask("Country Code (2 letters): ") }
      set(:state) { Capistrano::CLI.ui.ask("State/Province: ") }
      set(:city) { Capistrano::CLI.ui.ask("City: ") }
      set(:domain) { Capistrano::CLI.ui.ask("Common Name (domain): ") }
      run "cd /data/ssl/ && openssl req -new -nodes -days 365 -newkey rsa:#{length} -subj '/C=#{country}/ST=#{state}/L=#{city}/CN=#{domain}' -keyout #{domain}.com.key -out #{domain}.com.csr"
    end   
  end
end