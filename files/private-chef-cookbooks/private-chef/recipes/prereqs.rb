prereqs_check "Check and report on all needed OPC ports" do
  message "These ports need to be unused to allow Opscode Private Chef to run properly"
  port [
    node['private_chef']['couchdb']['port'],
    node['private_chef']['rabbitmq']['node_port'],
    node['private_chef']['opscode-solr']['port'],
    node['private_chef']['opscode-chef']['upload_port'],
    node['private_chef']['opscode-chef']['upload_internal_port'],
    node['private_chef']['opscode-chef']['port'],
    node['private_chef']['opscode-erchef']['port'],
    node['private_chef']['opscode-webui']['port'],
    node['private_chef']['lb_internal']['chef_port'],
    node['private_chef']['lb_internal']['account_port'],
    node['private_chef']['lb_internal']['authz_port'],
    node['private_chef']['nginx']['ssl_port'],
    node['private_chef']['nginx']['non_ssl_port'],
    node['private_chef']['postgresql']['port'],
    node['private_chef']['redis']['port'],
    node['private_chef']['opscode-authz']['port'],
    node['private_chef']['bookshelf']['port'],
    node['private_chef']['opscode-certificate']['port'],
    node['private_chef']['opscode-org-creator']['port'],
    node['private_chef']['opscode-account']['port'],
    node['private_chef']['estatsd']['port'],
    node['private_chef']['nagios']['port'],
    node['private_chef']['nagios']['fcgiwrap_port'],
    node['private_chef']['nagios']['php_fpm_port'],
    node['private_chef']['nrpe']['port'],
    node['private_chef']['drbd']['primary']['port'],
    node['private_chef']['drbd']['secondary']['port']
    ]
  check true
end

prereqs_check "Check and report on qpid" do
  message "qpidd may be running, please stop and disable the service to allow Opscode Private Chef to run properly"
  check "pgrep qpidd"
end

prereqs_check "Check and report on apache" do
  message "Apache may be running, please stop and disable the service to allow Opscode Private Chef to run properly"
  check "pgrep \"apache|httpd\""
end

prereqs_check "Check and report on hostname length" do
  message "The current hostname will result in a > openssl max size CommonName. Hostname length must be 64 characters or less to allow Opscode Private Chef to run properly"
  check "test `hostname | wc -c` -gt 64 -o `hostname -f | wc -c` -gt 64"
end

prereqs_check "Check and report on presence of FQDN" do
  message "The system must have a FQDN to allow Opscode Private Chef to run properly"
  check "test `hostname -f | wc -c` -lt 1"
end
