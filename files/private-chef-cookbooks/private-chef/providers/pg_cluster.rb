def whyrun_supported?
  true
end

use_inline_resources

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
end
