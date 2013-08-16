#
# Author:: Christopher Maier (<cm@opscode.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#
# Following an upgrade to Private Chef 11, some old data will remain
# behind.  This recipe removes all that stuff, following the upgrade,
# only when the user is satisfied with the state of their system.

private_chef_package_cleaner "opscode-authz" do
  directories ["/var/opt/opscode/opscode-authz",
               "/var/log/opscode/opscode-authz",
               "/opt/opscode/embedded/service/opscode-authz",
               "/var/opt/opscode/couchdb/db/.authorization_design"]
  files ["/var/opt/opscode/couchdb/db/authorization.couch",
         "/var/opt/opscode/couchdb/db/authorization_design_documents.couch"]
end

private_chef_package_cleaner "nagios" do
  directories ["/opt/opscode/embedded/nagios",
               "/var/opt/opscode/nagios",
               "/var/log/opscode/nagios"]
  users ["opscode-nagios",
         "opscode-nagios-cmd"]
  groups ["opscode-nagios",
          "opscode-nagios-cmd"]
  files ["/var/log/opscode/nginx/nagios.access.log",
         "/var/log/opscode/nginx/nagios.error.log",
         "/etc/opscode/logrotate.d/nagios"]
end

private_chef_package_cleaner "nrpe" do
  directories ["/var/opt/opscode/nrpe",
               "/var/log/opscode/nrpe"]
end

private_chef_package_cleaner "fastcgi" do
  # There isn't really a "service", per se for this
  is_service false
  files ["/opt/opscode/embedded/conf/fastcgi.conf",
         "/var/opt/opscode/nginx/etc/fastcgi.conf"]
end

private_chef_package_cleaner "fcgiwrap" do
  directories ["/var/log/opscode/fcgiwrap"]
end

private_chef_package_cleaner "php-fpm" do
  directories ["/var/log/opscode/php-fpm"]
end

private_chef_package_cleaner "opscode-chef" do
  directories ["/var/opt/opscode/opscode-chef",
               "/var/log/opscode/opscode-chef",
               "/opt/opscode/embedded/service/opscode-chef"]
end

# Remove old PostgreSQL data directory
#
# pg_upgrade will helpfully generate a cleanup script which removes
# the previous database cluster.  This is nice, because we don't have
# to worry about keeping track of the location of the old cluster.
execute "remove_old_postgres_data_directory" do
  cleanup_script = "#{node['private_chef']['postgresql']['data_dir']}/delete_old_cluster.sh"
  command cleanup_script
  only_if {File.exists? cleanup_script}
  # The script itself is idempotent; it just runs an 'rm -Rf' on the
  # old $PG_DATA directory
end
