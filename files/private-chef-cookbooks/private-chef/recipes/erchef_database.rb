private_chef_pg_database "opscode_chef" do
#  owner node['private_chef']['postgresql']['username'] # Do we really want this?
  notifies :run, "execute[chef-server-schema]", :immediately
end

# Sqitch runs are idempotent. These are turned on
# assuming that the customer has already upgraded to EC 11.0.0
execute "chef-server-schema" do
  command "sqitch --db-name opscode_chef deploy --verify"
  # OSC schema is a dependency of the EC schema, and managed by it
  cwd "/opt/opscode/embedded/service/enterprise-chef-server-schema/deps/chef-server-schema"
  user node['private_chef']['postgresql']['username']
  returns [0,1]
end

execute "enterprise-chef-server-schema" do
  command "sqitch --db-name opscode_chef deploy --verify"
  cwd "/opt/opscode/embedded/service/enterprise-chef-server-schema"
  user node['private_chef']['postgresql']['username']
  returns [0,1]
end


# Create Database Users

# TODO: Originally these users were created WITH SUPERUSER... is that still necessary?
private_chef_pg_user node['private_chef']['postgresql']['sql_user'] do
  password node['private_chef']['postgresql']['sql_password']
  superuser true
  notifies :run, "execute[grant opscode_chef privileges]", :immediately
end

execute "grant opscode_chef privileges" do
  command <<-EOM.gsub(/\s+/," ").strip!
    psql --dbname opscode_chef
         --command "GRANT ALL PRIVILEGES ON DATABASE opscode_chef TO #{node['private_chef']['postgresql']['sql_user']};"
  EOM
  user node['private_chef']['postgresql']['username']
  action :nothing
end

private_chef_pg_user node['private_chef']['postgresql']['sql_ro_user'] do
  password node['private_chef']['postgresql']['sql_ro_password']
  superuser true
  notifies :run, "execute[grant opscode_chef_ro privileges]", :immediately
end

execute "grant opscode_chef_ro privileges" do
  command <<-EOM.gsub(/\s+/," ").strip!
    psql --dbname opscode_chef
         --command "GRANT ALL PRIVILEGES ON DATABASE opscode_chef TO #{node['private_chef']['postgresql']['sql_ro_user']};"
  EOM
  user node['private_chef']['postgresql']['username']
  action :nothing
end
