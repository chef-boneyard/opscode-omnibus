opscode_tsdbd_dir = node['private_chef']['opscode-tsdbd']['dir']
opscode_tsdbd_etc_dir = File.join(opscode_tsdbd_dir, "etc")
opscode_tsdbd_log_dir = node['private_chef']['opscode-tsdbd']['log_directory']
opscode_tsdbd_sasl_log_dir = File.join(opscode_tsdbd_log_dir, "sasl")
[
  opscode_tsdbd_dir,
  opscode_tsdbd_etc_dir,
  opscode_tsdbd_log_dir,
  opscode_tsdbd_sasl_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

link "/opt/opscode/embedded/service/opscode-tsdbd/log" do
  to opscode_tsdbd_log_dir
end

template "/opt/opscode/embedded/service/opscode-tsdbd/bin/tsdbd" do
  source "tsdbd.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(node['private_chef']['opscode-tsdbd'].to_hash)
  notifies :restart, 'service[opscode-tsdbd]' if OmnibusHelper.should_notify?("opscode-tsdbd")
end

tsdbd_config = File.join(opscode_tsdbd_etc_dir, "app.config")

template tsdbd_config do
  source "tsdbd.config.erb"
  mode "644"
  variables(node['private_chef']['opscode-tsdbd'].to_hash)
  notifies :restart, 'service[opscode-tsdbd]' if OmnibusHelper.should_notify?("opscode-tsdbd")
end

link "/opt/opscode/embedded/service/opscode-tsdbd/etc/app.config" do
  to tsdbd_config
end


runit_service "opscode-tsdbd" do
  down node['private_chef']['opscode-tsdbd']['ha']
  options({
    :log_directory => opscode_tsdbd_log_dir
  }.merge(params))
end

if node['private_chef']['bootstrap']['enable']
	execute "/opt/opscode/bin/private-chef-ctl start opscode-tsdbd" do
		retries 20
	end
end

add_nagios_hostgroup("opscode-tsdbd")
