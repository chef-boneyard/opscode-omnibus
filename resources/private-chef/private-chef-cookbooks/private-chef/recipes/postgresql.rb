#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2011 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "private-chef::old_postgres_cleanup"

postgresql_dir = node['private_chef']['postgresql']['dir']
postgresql_data_dir = node['private_chef']['postgresql']['data_dir']
postgresql_data_dir_symlink = File.join(postgresql_dir, "data")
postgresql_log_dir = node['private_chef']['postgresql']['log_directory']

# Postgres User Setup
user node['private_chef']['postgresql']['username'] do
  system true
  shell node['private_chef']['postgresql']['shell']
  home node['private_chef']['postgresql']['home']
end

# TODO: Currently this is set up to be a parent directory of
# node['private_chef']['postgresql']['dir'].  Is it necessary that
# this is exposed as a settable attribute, or can we make some
# simplifying assumptions about our directory structure?
directory node['private_chef']['postgresql']['home'] do
  owner node['private_chef']['postgresql']['username']
  recursive true
  mode "0700"
end

file File.join(node['private_chef']['postgresql']['home'], ".profile") do
  owner node['private_chef']['postgresql']['username']
  mode "0644"
  content <<-EOH
    PATH=#{node['private_chef']['postgresql']['user_path']}
  EOH
end

####

directory postgresql_log_dir do
  owner node['private_chef']['user']['username']
  recursive true
end

directory postgresql_dir do
  owner node['private_chef']['postgresql']['username']
  recursive true
  mode "0700"
end

####

if File.directory?("/etc/sysctl.d") && File.exists?("/etc/init.d/procps")
  # smells like ubuntu...
  service "procps" do
    action :nothing
  end

  template "/etc/sysctl.d/90-postgresql.conf" do
    source "90-postgresql.conf.sysctl.erb"
    owner "root"
    mode  "0644"
    variables(node['private_chef']['postgresql'].to_hash)
    notifies :start, 'service[procps]', :immediately
  end
else
  # hope this works...
  execute "sysctl" do
    command "/sbin/sysctl -p /etc/sysctl.conf"
    action :nothing
  end

  # this is why i want cfengine-style editfile resources with appendifnosuchline, etc...
  bash "add shm settings" do
    user "root"
    code <<-EOF
      echo 'kernel.shmmax = 17179869184' >> /etc/sysctl.conf
      echo 'kernel.shmall = 4194304' >> /etc/sysctl.conf
    EOF
    notifies :run, 'execute[sysctl]', :immediately
    not_if "egrep '^kernel.shmmax = ' /etc/sysctl.conf"
  end
end

# Upgrade the cluster if you gotta
private_chef_pg_upgrade "upgrade_if_necessary"

private_chef_pg_cluster postgresql_data_dir do
  notifies :restart, 'runit_service[postgresql]' if is_data_master?
end

link postgresql_data_dir_symlink do
  to postgresql_data_dir
  not_if { postgresql_data_dir == postgresql_data_dir_symlink }
end

component_runit_service "postgresql" do
  control ['t']
end

# NOTE: These recipes are written idempotently, but require a running
# PostgreSQL service.  They should run each time (on the appropriate
# backend machine, of course), because they also handle schema
# upgrades for new releases of Enterprise Chef.  As a result, we can't
# just do a check against node['private_chef']['bootstrap']['enable'],
# which would only run them one time.
if is_data_master?
  execute "/opt/opscode/bin/private-chef-ctl start postgresql" do
    retries 20
  end
  include_recipe "private-chef::erchef_database"
  include_recipe "private-chef::bifrost_database"
  include_recipe "private-chef::oc_id_database"
end
