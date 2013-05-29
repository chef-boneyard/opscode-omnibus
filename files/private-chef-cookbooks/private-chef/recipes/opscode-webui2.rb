#
# Author:: Nathan L Smith (<smith@opscode.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#

# TODO: HA business
# TODO: S3 business
# TODO: redis persistence
# TODO: backups
# TODO: nginx
# TODO: software version

include_recipe 'runit'

should_notify = OmnibusHelper.should_notify?('opscode-webui2')
should_notify_events = OmnibusHelper.should_notify?('opscode-webui2-events')
should_notify_worker = OmnibusHelper.should_notify?('opscode-webui2-worker')

private_chef_redis_url = "redis://#{node['private_chef']['redis']['bind']}:#{node['private_chef']['redis']['port']}/#{node['private_chef']['opscode-webui2']['redis_db']}"

runit_options = {
  :svlogd_size   => node['private_chef']['opscode-webui2']['svlogd_size'],
  :svlogd_num    => node['private_chef']['opscode-webui2']['svlogd_num']
}

# Create directories

private_chef_webui2_dir = node['private_chef']['opscode-webui2']['dir']
private_chef_webui2_etc_dir = File.join(private_chef_webui2_dir, 'etc')
private_chef_webui2_tmp_dir = File.join(private_chef_webui2_dir, 'tmp')
private_chef_webui2_log_dir = node['private_chef']['opscode-webui2']['log_directory']
private_chef_webui2_events_log_dir = File.join(
  private_chef_webui2_log_dir, 'events'
)
private_chef_webui2_worker_log_dir = File.join(
  private_chef_webui2_log_dir, 'worker'
)
private_chef_webui2_worker_run_dir = File.join(
  private_chef_webui2_dir, 'run', 'sidekiq'
)

[
  private_chef_webui2_tmp_dir,
  private_chef_webui2_worker_run_dir,
  private_chef_webui2_log_dir,
  private_chef_webui2_events_log_dir,
  private_chef_webui2_worker_log_dir,
  '/opt/opscode/embedded/service/opscode-webui2/public'
].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

link '/opt/opscode/embedded/service/opscode-webui2/tmp' do
  to private_chef_webui2_tmp_dir
end

# Configuration files

file "#{private_chef_webui2_etc_dir}/opscode_platform.yml" do
  owner node['private_chef']['user']['username']
  mode '0600'
  content({
    'production' => {
      'key_file' => node['private_chef']['opscode-webui2']['private_key'],
      'origin'   => node['private_chef']['lb']['api_fqdn'],
      'url'      => "https://#{node['private_chef']['lb']['api_fqdn']}:#{node['private_chef']['opscode-webui2']['external']['port']}",
      'user'     => node['private_chef']['opscode-webui2']['proxy_user']
    }
  }.to_yaml)
  notifies :restart, 'service[opscode-webui2]' if should_notify
  notifies :restart, 'service[opscode-webui2-events]' if should_notify_events
  notifies :restart, 'service[opscode-webui2-worker]' if should_notify_worker
end

link '/opt/opscode/embedded/service/opscode-webui2/config/opscode_platform.yml' do
  to "#{private_chef_webui2_etc_dir}/opscode_platform.yml"
end

file "#{private_chef_webui2_etc_dir}/secret_token.rb" do
  owner node['private_chef']['user']['username']
  mode '0600'
  content "OpscodeWebui::Application.config = #{node['private_chef']['opscode-webui2']['secret_token']}"
  notifies :restart, 'service[opscode-webui2]' if should_notify
  notifies :restart, 'service[opscode-webui2-events]' if should_notify_events
  notifies :restart, 'service[opscode-webui2-worker]' if should_notify_worker
end

link '/opt/opscode/embedded/service/opscode-webui2/config/secret_token.rb' do
  to "#{private_chef_webui2_etc_dir}/secret_token.rb"
end

template "#{node['private_chef']['nginx']['dir']}/etc/nginx.d/opscode-webui2.conf" do
  source 'opscode-webui2-nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(node['private_chef']['nginx'].merge({
    :port => node['private_chef']['opscode-webui2']['external']['port']
  }))
  notifies :restart, 'service[nginx]' if OmnibusHelper.should_notify?('nginx')
end

# Asset compilation

execute 'compile webui2 assets' do
  command 'bundle exec rake assets:precompile'
  cwd '/opt/opscode/embedded/service/opscode-webui2'
  user node['private_chef']['user']['username']
  creates '/opt/opscode/embedded/service/opscode-webui2/public/assets/manifest.yml'
  notifies :restart, 'service[opscode-webui2]' if should_notify
end

# Web service configuration

unicorn_config File.join(private_chef_webui2_etc_dir, "unicorn.rb") do
  listen node['private_chef']['opscode-webui2']['listen'] => {
    :backlog     => node['private_chef']['opscode-webui2']['backlog'],
    :tcp_nodelay => node['private_chef']['opscode-webui2']['tcp_nodelay']
  }
  preload_app true
  worker_timeout node['private_chef']['opscode-webui2']['worker_timeout']
  worker_processes node['private_chef']['opscode-webui2']['worker_processes']
  owner node['private_chef']['user']['username']
  mode '0600'
  notifies :restart, 'service[opscode-webui2]' if should_notify
  notifies :restart, 'service[opscode-webui2-events]' if should_notify_events
  notifies :restart, 'service[opscode-webui2-worker]' if should_notify_worker

  if node['private_chef']['redis']['enable']
    after_fork """
    Sidekiq.configure_server do |config|
      config.redis = { :url => '#{private_chef_redis_url}', :namespace => 'sidekiq' }
    end
    Sidekiq.configure_client do |config|
      config.redis = { :url => '#{private_chef_redis_url}', :namespace => 'sidekiq' }
    end
    """
  end
end

runit_service 'opscode-webui2' do
  options runit_options.merge({ :log_directory => private_chef_webui2_log_dir })
end

add_nagios_hostgroup('opscode-webui2')

# Event service configuration

runit_service 'opscode-webui2-events' do
  options runit_options.merge({
    :log_directory => private_chef_webui2_events_log_dir,
    :port          => node['private_chef']['opscode-webui2-events']['port']
  })
end
# Increase the timeout for restart
service_resource = resources('service[opscode-webui2-events]')
service_resource.restart_command "#{node['runit']['sv_bin']} -w 300 restart opscode-webui2-events"

add_nagios_hostgroup('opscode-webui2-events')

# Worker service configuration

runit_service 'opscode-webui2-worker' do
  options runit_options.merge({
    :log_directory => private_chef_webui2_worker_log_dir,
    :run_directory => private_chef_webui2_worker_run_dir
  })
end

# Increase the timeout for restart
service_resource = resources('service[opscode-webui2-worker]')
service_resource.restart_command "#{node['runit']['sv_bin']} -w 30 restart opscode-webui2-worker"

add_nagios_hostgroup('opscode-webui2-worker')
