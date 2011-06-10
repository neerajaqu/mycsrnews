#
# Chef-Solo Capistrano Bootstrap
#
# usage:
#   cap chef:bootstrap <dna> <remote_host>
#
# NOTICE OF LICENSE
#
# Copyright (c) 2010 Mike Smullin <mike@smullindesign.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# configuration
#default_run_options[:pty] = true # fix to display interactive password prompts
#target = ARGV[-1].split(':')
#if (u = ARGV[-1].split('@')[-2])
#  set(:user, u)
#end
#role :target, target[0]
#set :port, target[1] || 22
#cwd = File.expand_path(File.dirname(__FILE__))
#cookbook_dir = '/var/chef-solo'
#dna_dir = '/etc/chef'
#node = ARGV[-2]

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :chef do
    desc "Initialize a fresh Ubuntu install; create users, groups, upload pubkey, etc."
    task :init_server do
      set :user, "root"

      location = fetch(:template_dir, "config/deploy/templates") + '/sudoers.erb'
      config = ERB.new(File.read(location))
      put config.result(binding), "/tmp/sudoers"
      sudo "chmod 0440 /tmp/sudoers"
      sudo "chmod 0440 /tmp/sudoers"
      sudo "chown root:root /tmp/sudoers"
      sudo "mv /tmp/sudoers /etc/sudoers"

      sudo 'groupadd developers; exit 0'
      #create_user `whoami`, 'l0WlW3pH6hxj.', 'developers', 'sudo', `cat ~/.ssh/id_rsa.pub`
      create_user 'deploy', '4126c014250095a3a07e3ec76cbf2301a1836d2cf5b', 'developers', 'sudo', `cat ~/.ssh/id_rsa.pub`
      sudo 'rm /etc/motd; exit 0'
      abort 'Prep successful!'
    end

    desc "Bootstrap an Ubuntu 10.04 server and kick-start Chef-Solo"
    task :bootstrap do
      #install_rvm_ruby
      #install_ree
      install_mri_ruby
      install_chef
      #install_cookbook_repo
      #install_dna
      #solo
    end

    desc "Install Ruby Enterprise Edition"
    # see also: http://www.rubyenterpriseedition.com/download.html
    task :install_ree do
      ree_version = 'ruby-enterprise-1.8.7-2010.02'
      ree_prefix = '/usr/local'
      sudo 'aptitude install -y zlib1g-dev libssl-dev libreadline5-dev' # REE dependencies
      run "cd /tmp && wget http://rubyforge.org/frs/download.php/71096/#{ree_version}.tar.gz && tar zxvf #{ree_version}.tar.gz"
      sudo "mkdir -p #{ree_prefix}/lib/ruby/gems/1.8/gems" # workaround for bug in REE installer
      sudo "/tmp/#{ree_version}/installer -a #{ree_prefix} --dont-install-useful-gems --no-dev-docs"
      run "echo 'gem: --no-ri --no-rdoc' | #{sudo} tee -a /etc/gemrc"
    end

    desc "install Ruby (using RVM)"
    # see also: http://rohitarondekar.com/articles/installing-rails3-beta3-on-ubuntu-using-rvm
    task :install_rvm_ruby do
      rvm_ruby_version = '1.9.2-p0'
      set :default_environment, {
        'PATH'         => "/usr/local/rvm/gems/ruby-#{rvm_ruby_version}/bin:/usr/local/rvm/gems/ruby-#{rvm_ruby_version}@global/bin:/usr/local/rvm/rubies/ruby-#{rvm_ruby_version}/bin:$PATH",
        'RUBY_VERSION' => "ruby #{rvm_ruby_version}",
        'GEM_HOME'     => "/usr/local/rvm/gems/ruby-#{rvm_ruby_version}",
        'GEM_PATH'     => "/usr/local/rvm/gems/ruby-#{rvm_ruby_version}:/usr/local/rvm/gems/ruby-#{rvm_ruby_version}@global",
        'BUNDLE_PATH'  => "/usr/local/rvm/gems/ruby-#{rvm_ruby_version}"
      }
      msudo [
        # install RVM
        'aptitude install -y curl git-core',
        "curl -L http://bit.ly/rvm-install-system-wide | #{sudo} bash",
        %q(sed -i 's/^\[/# [/' /root/.bashrc),
        %q(echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"' | sudo tee -a /root/.bashrc),

        # dependencies for compiling Ruby
        'aptitude install -y bison build-essential autoconf zlib1g-dev libssl-dev libxml2-dev libreadline6-dev',

        # RVM packages for Ruby
        'rvm package install openssl',
        'rvm package install readline',

        # install Ruby
        "rvm install #{rvm_ruby_version} -C --with-openssl-dir=$rvm_path/usr,--with-readline-dir=$rvm_path/usr",
        "rvm use #{rvm_ruby_version} --default",
        "echo 'gem: --no-ri --no-rdoc' | #{sudo} tee -a /etc/gemrc" # saves time; don't need docs on server
      ]
      mrun [
        "#{sudo} usermod -a -G rvm `whoami`", # add user to the RVM group
        %q(sed -i 's/^\[/# [/' ~/.bashrc),
        %q(echo '[[ -s "/usr/local/rvm/scripts/rvm" ]] && source "/usr/local/rvm/scripts/rvm"' | tee -a ~/.bashrc)
      ]
    end

    desc "Install MRI Ruby"
    task :install_mri_ruby do
      set :default_environment, {
        'PATH' => "/var/lib/gems/1.8/bin:$PATH"
      }
      msudo [
        'aptitude update -y',

        # Install git and build-essential
        'aptitude install -y git-core build-essential',

        # Install ruby
        'aptitude install -y ruby libopenssl-ruby ruby1.8-dev irb rubygems',

        # Add rubygems to path
        #'export PATH=/var/lib/gems/1.8/bin:$PATH',

        # Update rubygems
        'gem install rubygems-update',
        '`which update_rubygems`',
        # saves time; don't need docs on server
        "echo 'gem: --no-ri --no-rdoc' | #{sudo} tee -a /etc/gemrc",

        # Install bundler and god gems
        'gem install bundler',
        'gem install god'
      ]
    end

    desc "Install Chef and Ohai gems as root"
    task :install_chef do
      sudo_env 'gem source -a http://gems.opscode.com/'
      sudo_env 'gem install ohai chef'
    end

    desc "Install Cookbook Repository from cwd"
    task :install_cookbook_repo do
      sudo 'aptitude install -y rsync'
      sudo "mkdir -m 0775 -p #{cookbook_dir}"
      sudo "chown `whoami` #{cookbook_dir}"
      reinstall_cookbook_repo
    end

    desc "Re-install Cookbook Repository from cwd"
    task :reinstall_cookbook_repo do
      rsync cwd + '/', cookbook_dir
    end

    desc "Install ./dna/*.json for specified node"
    task :install_dna do
      sudo 'aptitude install -y rsync'
      sudo "mkdir -m 0775 -p #{dna_dir}"
      sudo "chown `whoami` #{dna_dir}"
      put %Q(file_cache_path "#{cookbook_dir}"
  cookbook_path ["#{cookbook_dir}/cookbooks", "#{cookbook_dir}/site-cookbooks"]
  role_path "#{cookbook_dir}/roles"), "#{dna_dir}/solo.rb", :via => :scp, :mode => "0644"
      reinstall_dna
    end

    desc "Re-install ./dna/*.json for specified node"
    task :reinstall_dna do
      rsync "#{cwd}/dna/#{node}.json", "#{dna_dir}/dna.json"
    end

    desc "Execute Chef-Solo"
    task :solo do
      sudo_env "chef-solo -c #{dna_dir}/solo.rb -j #{dna_dir}/dna.json -l debug"

      exit # subsequent args are not tasks to be run
    end

    desc "Reinstall and Execute Chef-Solo"
    task :resolo do
      reinstall_cookbook_repo
      reinstall_dna
      solo
    end

    desc "Cleanup, Reinstall, and Execute Chef-Solo"
    task :clean_solo do
      cleanup
      install_chef
      install_cookbook_repo
      install_dna
      solo
    end

    desc "Remove all traces of Chef"
    task :cleanup do
      sudo "rm -rf #{dna_dir} #{cookbook_dir}"
      sudo_env 'gem uninstall -ax chef ohai'
    end
  end
end


# helpers
#def create_user(user, pass, group, groups, pubkey)
#  run "groupadd #{user}; exit 0"
#  run "useradd -s /bin/bash -m -g #{group} -G #{groups},#{user} -p #{pass} #{user}"
#  ssh_dir = "/home/#{user}/.ssh"
#  run "mkdir -pm700 #{ssh_dir} && touch #{ssh_dir}/authorized_keys && chmod 600 #{ssh_dir}/authorized_keys && echo '#{pubkey}' >> #{ssh_dir}/authorized_keys && chown -R #{user}.#{group} #{ssh_dir}"
#  #run "sed -ir 's/^\\(AllowUsers\\s\\+.\\+\\)$/\\1 #{user}/' /etc/ssh/sshd_config"
#  #run 'service ssh restart'
#end
def create_user(user, pass, group, groups, pubkey)
  ssh_dir = "/home/#{user}/.ssh"
  msudo [
    "groupadd #{user}; exit 0",
    "useradd -s /bin/bash -m -g #{group} -G #{groups},#{user} -p #{pass} #{user}",
    "mkdir -pm700 #{ssh_dir} ",
    "touch #{ssh_dir}/authorized_keys ",
    "chmod 600 #{ssh_dir}/authorized_keys ",
    "echo '#{pubkey}' | sudo tee -a #{ssh_dir}/authorized_keys",
    "chown -R #{user}.#{group} #{ssh_dir}"
  ]
  #run "sed -ir 's/^\\(AllowUsers\\s\\+.\\+\\)$/\\1 #{user}/' /etc/ssh/sshd_config"
  #run 'service ssh restart'
end

def sudo_env(cmd)
  run "#{sudo} -i #{cmd}"
end

def msudo(cmds)
  cmds.each do |cmd|
    sudo cmd
  end
end

def mrun(cmds)
  cmds.each do |cmd|
    run cmd
  end
end

def rsync(from, to)
  find_servers_for_task(current_task).each do |server|
    puts `rsync -avz -e "ssh -p#{port}" "#{from}" "#{ENV['USER']}@#{server}:#{to}" \
      --exclude ".svn" --exclude ".git"`
  end
end

def bash(cmd)
  run %Q(echo "#{cmd}" > /tmp/bash)
  run "sh /tmp/bash"
  run "rm /tmp/bash"
end

def bash_sudo(cmd)
  run %Q(echo "#{cmd}" > /tmp/bash)
  sudo_env "sh /tmp/bash"
  run "rm /tmp/bash"
end
