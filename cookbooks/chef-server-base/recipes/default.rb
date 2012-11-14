tarfile = "#{node.base_tmp_dir}/#{node.base_tar_file}"

remote_file tarfile do
  source node.base_tarball_url
  mode 0644
end

execute "extract Chef server base" do
  cwd node.base_tmp_dir
  command %{tar xzf "#{node.base_tar_file}"}
  creates "/opt/opscode"
end
