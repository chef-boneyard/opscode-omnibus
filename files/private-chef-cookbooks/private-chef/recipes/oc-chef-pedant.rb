#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# All Rights Reserved
#

pedant_dir = node['private_chef']['oc-chef-pedant']['dir']
pedant_etc_dir = File.join(pedant_dir, "etc")
pedant_log_dir = node['private_chef']['oc-chef-pedant']['log_directory']
[
  pedant_dir,
  pedant_etc_dir,
  pedant_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

pedant_config = File.join(pedant_etc_dir, "pedant_config.rb")

template pedant_config do
  owner "root"
  group "root"
  mode  "0755"
  variables({
    :api_url  => node['private_chef']['nginx']['url'],
    :solr_url => node['private_chef']['opscode-solr']['url']
  }.merge(node['private_chef']['oc-chef-pedant'].to_hash))
end
