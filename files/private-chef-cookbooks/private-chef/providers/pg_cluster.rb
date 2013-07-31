def whyrun_supported?
  true
end

use_inline_resources

# Initialize a PostgreSQL database cluster.  Ensures the data
# directory exists, runs initdb, and sets up postgresql.conf and
# pg_hba.conf files.
action :init do

  # Ensure the data directoy exists first!
  directory new_resource.data_dir do
    owner node['private_chef']['postgresql']['username']
    mode "0700"
    recursive true
  end

  # Initialize the cluster
  execute "initialize_cluster_#{new_resource.data_dir}" do
    command "initdb --pgdata #{new_resource.data_dir} --locale C"
    user node['private_chef']['postgresql']['username']
    environment({"PATH" => "/opt/opscode/embedded/bin:#{ENV['PATH']}"})
    not_if { File.exists?(File.join(new_resource.data.dir, "PG_VERSION")) }
  end

  # Create configuration files
  ["postgresql.conf", "pg_hba.conf"].each do |config_file|
    template File.join(new_resource.data_dir, config_file) do
      owner node['private_chef']['postgresql']['username']
      mode "0644"
      variables(node['private_chef']['postgresql'].to_hash)
      # TODO: Why "runit_service" instead of "service"?
      notifies :restart, 'runit_service[postgresql]' if OmnibusHelper.should_notify?("postgresql")
    end
  end

end
