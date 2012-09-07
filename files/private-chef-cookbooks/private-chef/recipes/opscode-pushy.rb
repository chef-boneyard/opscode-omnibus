#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# All Rights Reserved

opscode_pushy_dir = node['private_chef']['opscode-pushy']['dir']
opscode_pushy_etc_dir = File.join(opscode_pushy_dir, "etc")
opscode_pushy_log_dir = node['private_chef']['opscode-pushy']['log_directory']
opscode_pushy_sasl_log_dir = File.join(opscode_pushy_dir, "sasl")
[
  opscode_pushy_dir,
  opscode_pushy_etc_dir,
  opscode_pushy_log_dir,
  opscode_pushy_sasl_log_dir,
].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

link "/opt/opscode/embedded/service/opscode-pushy/log" do
  to opscode_pushy_log_dir
end

link "/etc/opscode/client_public.pem" do
  to "/opt/opscode/embedded/service/opscode-pushy/etc/client_public.pem"
end

template "/opt/opscode/embedded/service/opscode-pushy/bin/pushy" do
  source "pushy.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(node['private_chef']['opscode-pushy'].to_hash)
  notifies :restart, 'service[opscode-pushy]' if OmnibusHelper.should_notify?("opscode-pushy")
end

pushy_config = File.join(opscode_pushy_etc_dir, "app.config")

template pushy_config do
  source "pushy.config.erb"
  mode "644"
  variables(node['private_chef']['opscode-pushy'].to_hash)
  notifies :restart, 'service[opscode-pushy]' if OmnibusHelper.should_notify?("opscode-pushy")
end

link "/opt/opscode/embedded/service/opscode-pushy/etc/app.config" do
  to pushy_config
end

runit_service "opscode-pushy" do
  down node['private_chef']['opscode-pushy']['ha']
  options({
    :log_directory => opscode_pushy_log_dir
  }.merge(params))
end

if node['private_chef']['bootstrap']['enable']
  execute "/opt/opscode/bin/private-chef-ctl opscode-pushy start" do
    retries 20
  end
end

# add_nagios_hostgroup("opscode-pushy")

