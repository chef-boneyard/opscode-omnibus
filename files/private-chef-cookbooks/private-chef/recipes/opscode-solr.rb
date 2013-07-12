#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
#
# All Rights Reserved
#

solr_dir = node['private_chef']['opscode-solr']['dir']
solr_etc_dir = File.join(solr_dir, "etc")
solr_jetty_dir = File.join(solr_dir, "jetty")
solr_data_dir = node['private_chef']['opscode-solr']['data_dir']
solr_data_dir_symlink = File.join(solr_dir, "data")
solr_home_dir = File.join(solr_dir, "home")
solr_log_dir = node['private_chef']['opscode-solr']['log_directory']

[ solr_dir, solr_etc_dir, solr_data_dir, solr_home_dir, solr_log_dir ].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

link solr_data_dir_symlink do
  to solr_data_dir
  not_if { solr_data_dir == solr_data_dir_symlink }
end

solr_config = File.join(solr_etc_dir, "solr.rb")

template File.join(solr_etc_dir, "solr.rb") do
  source "solr.rb.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(node['private_chef']['opscode-solr'].to_hash)
end

should_notify = OmnibusHelper.should_notify?("opscode-solr")

solr_installed_file = File.join(solr_dir, "installed")

execute "cp -R /opt/opscode/embedded/service/opscode-solr/home/conf #{File.join(solr_home_dir, 'conf')}" do
  not_if { File.exists?(solr_installed_file) }
  notifies(:restart, "service[opscode-solr]") if should_notify
end

execute "cp -R /opt/opscode/embedded/service/opscode-solr/jetty #{File.dirname(solr_jetty_dir)}" do
  not_if { File.exists?(solr_installed_file) }
  notifies(:restart, "service[opscode-solr]") if should_notify
end

execute "chown -R #{node['private_chef']['user']['username']} #{solr_dir}" do
  not_if { File.exists?(solr_installed_file) }
end

file solr_installed_file do
  owner "root"
  group "root"
  mode "0644"
  content "Delete me to force re-install solr - dangerous"
  action :create
end

template File.join(solr_jetty_dir, "etc", "jetty.xml") do
  owner node['private_chef']['user']['username']
  mode "0644"
  source "jetty.xml.erb"
  variables(node['private_chef']['opscode-solr'].to_hash.merge(node['private_chef']['logs'].to_hash))
  notifies :restart, 'service[opscode-solr]' if should_notify
end

template File.join(solr_home_dir, "conf", "solrconfig.xml") do
  owner node['private_chef']['user']['username']
  mode "0644"
  source "solrconfig.xml.erb"
  variables(node['private_chef']['opscode-solr'].to_hash)
  notifies :restart, 'service[opscode-solr]' if should_notify
end

node.default['private_chef']['opscode-solr']['command'] =  "java -Xmx#{node['private_chef']['opscode-solr']['heap_size']} -Xms#{node['private_chef']['opscode-solr']['heap_size']}"
node.default['private_chef']['opscode-solr']['command'] << " -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8086 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
node.default['private_chef']['opscode-solr']['command'] << " -Dsolr.data.dir=#{solr_data_dir}"
node.default['private_chef']['opscode-solr']['command'] << " -Dsolr.solr.home=#{solr_home_dir}"
node.default['private_chef']['opscode-solr']['command'] << " -server"
node.default['private_chef']['opscode-solr']['command'] << " -jar '#{solr_jetty_dir}/start.jar'"

component_runit_service "opscode-solr"
