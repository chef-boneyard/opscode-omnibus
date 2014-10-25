#
# Author:: Douglas Triggs (<doug@getchef.com>)
# Copyright:: Copyright (c) 2014 Chef Software, Inc.
#
# All Rights Reserved
#

case node['platform_family']
when 'debian'

  apt_repository 'chef-stable' do
    uri "https://packagecloud.io/chef/stable/ubuntu/"
    key 'https://packagecloud.io/gpg.key'
    distribution 'lucid'
    deb_src true
    trusted true
    components %w( main )
  end

  # FIXME: We should test on higher versions of ubuntu https://github.com/opscode/opscode-omnibus/issues/460
  log "Chef Server packages and addons are not regression tested on #{node['platform']}-#{node['platform_version']}. They may install, but may not work, use at your own risk" do
    level :warn
    only_if { (platform?('ubuntu') && node['platform_version'].to_f > 12.04) || platform?('debian') }
  end

  # Performs an apt-get update
  include_recipe 'apt::default'

when 'rhel'

  major_version = node['platform_version'].split('.').first

  yum_repository 'chef-stable' do
    description 'Chef Stable Repo'
    baseurl "https://packagecloud.io/chef/stable/el/#{major_version}/$basearch"
    gpgkey 'https://downloads.getchef.com/chef.gpg.key'
    sslverify true
    sslcacert '/etc/pki/tls/certs/ca-bundle.crt'
    gpgcheck true
    action :create
  end

else
  # TODO: probably don't actually want to fail out?  Say, on any platform where
  # this would have to be done manually.
  raise "I don't know how to install addons for platform family: #{node['platform_family']}"
end

node['private_chef']['addons']['packages'].each do |pkg|
  package pkg do
    notifies :create, "ruby_block[addon_install_notification_#{pkg}]", :immediate
  end
end
