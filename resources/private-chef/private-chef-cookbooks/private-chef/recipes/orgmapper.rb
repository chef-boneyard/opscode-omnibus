
template "/etc/opscode/orgmapper.conf" do
  source "orgmapper.conf.erb"
  mode "0600"
  owner "root"
  group "root"
  variables(:helper => OmnibusHelper.new(node))
end

