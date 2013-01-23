#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
#
# All Rights Reserved
#

opscode_test_dir = "/opt/opscode/embedded/service/opscode-test"
opscode_test_config_dir = "/opt/opscode/embedded/service/opscode-test/bootstrapper-config"

template File.join(opscode_test_config_dir, "config.rb") do
  source "bootstrap-config.rb.erb"
  owner "root"
  group "root"
  mode "0600"
end

template File.join(opscode_test_config_dir, "script.rb") do
  source "bootstrap-script.rb.erb"
  owner "root"
  group "root"
  mode "0600"
end

bootstrap_status_file = "/var/opt/opscode/bootstrapped"

execute "boostrap-platform" do
  command "bash -c 'echo y | /opt/opscode/embedded/bin/bundle exec ./bin/bootstrap-platform -c ./bootstrapper-config/config.rb -s ./bootstrapper-config/script.rb'"
  cwd opscode_test_dir
  not_if { File.exists?(bootstrap_status_file) }
  notifies :restart, 'service[opscode-erchef]'
end

file bootstrap_status_file do 
  owner "root"
  group "root"
  mode "0600"
  content "You've been bootstrapped, punk. Delete me if you feel lucky. Do ya, Punk?"
end
