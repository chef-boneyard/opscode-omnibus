
redis_dir = node['private_chef']['redis']['dir']
redis_etc_dir = File.join(redis_dir, "etc")
redis_data_dir = File.join(redis_dir, "data")
redis_log_dir = node['private_chef']['redis']['log_directory']
[
  redis_dir,
  redis_etc_dir,
  redis_data_dir,
  redis_log_dir,
].each do |dir_name|
  directory dir_name do
    owner node['private_chef']['user']['username']
    mode '0700'
    recursive true
  end
end

redis_config = File.join(redis_etc_dir, "redis.conf")

template redis_config do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(node['private_chef']['redis'].to_hash)
  notifies :restart, 'service[redis]' if OmnibusHelper.should_notify?("redis")
end

runit_service "redis" do
  down node['private_chef']['redis']['ha']
  options({
    :log_directory => redis_log_dir,
    :svlogd_size => node['private_chef']['redis']['log_rotation']['file_maxbytes'],
    :svlogd_num => node['private_chef']['redis']['log_rotation']['num_to_keep']
  }.merge(params))
end

if node['private_chef']['bootstrap']['enable']
  execute "/opt/opscode/bin/private-chef-ctl start redis" do
  retries 20
end

# This will execute with every CCR, however key-value will only
# be set if they are not already present.
#ruby_block "set_redis_defaults" do
#  block do
#    require "redis"
#    redis = Redis.new(:host => "localhost", :port => 6379)
#    # red.hsetnx will only update the specified key if it is not
#    # already defined.
#    redis.pipelined do
#      redis.hsetnx "dl_default", "503_mode",             false
#      redis.hsetnx "dl_default", "couchdb_checksums",    true
#      redis.hsetnx "dl_default", "couchdb_cookbooks",    true
#      redis.hsetnx "dl_default", "couchdb_environments", true
#      redis.hsetnx "dl_default", "couchdb_roles",        true
#      redis.hsetnx "dl_default", "couchdb_data",         true
#      redis.hsetnx "dl_default", "couchdb_clients",      true
#      redis.hsetnx "dl_default", "disable_new_orgs",     false
#    end
#  end
#  action :create
#  only_if { enable_service }
#end
