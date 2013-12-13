#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
#
# All Rights Reserved
#

expander_dir = node['private_chef']['opscode-expander']['dir']
expander_etc_dir = File.join(expander_dir, "etc")
expander_log_dir = node['private_chef']['opscode-expander-solr4']['log_directory']
expander_reindexer_log_dir = node['private_chef']['opscode-expander-solr4']['reindexer_log_directory']

[ expander_dir, expander_etc_dir, expander_log_dir, expander_reindexer_log_dir ].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

expander_config = File.join(expander_etc_dir, "expander-solr4.rb")
reindexer_config = File.join(expander_etc_dir, "reindexer-solr4.rb")

template expander_config do
  source "expander-solr4.rb.erb"
  owner "root"
  group "root"
  mode "0644"
  options = node['private_chef']['opscode-expander'].to_hash
  options['reindexer'] = false
  variables(options)
  notifies :restart, 'runit_service[opscode-expander-solr4]' if is_data_master?
end

link "/opt/opscode/embedded/service/opscode-expander/conf/opscode-expander.rb" do
  to expander_config
end

template reindexer_config do
  source "expander-solr4.rb.erb"
  owner "root"
  group "root"
  mode "0644"
  options = node['private_chef']['opscode-expander'].to_hash
  options['reindexer'] = true
  variables(options)
end

component_runit_service "opscode-expander-solr4"
component_runit_service "opscode-expander-reindexer-solr4" do
  log_directory expander_reindexer_log_dir
  svlogd_size node['private_chef']['opscode-expander-solr4']['log_rotation']['file_maxbytes']
  svlogd_num node['private_chef']['opscode-expander-solr4']['log_rotation']['num_to_keep']
  ha node['private_chef']['opscode-expander']['ha']
end
