define :component_runit_service, :log_directory => nil, :svlogd_size => nil, :svlogd_num => nil, :ha => nil, :control => nil do

  component = params[:name]
  log_directory = params[:log_directory] || node['private_chef'][component]['log_directory']

  runit_service component do
    action :nothing
    retries 20
    control params[:control] if params[:control]
    options(
      :log_directory => log_directory
    )
  end

  template "#{log_directory}/config" do
    source "config.svlogd"
    mode "0644"
    owner "root"
    group "root"
    variables(
      :svlogd_size => ( params[:svlogd_size] || node['private_chef'][component]['log_rotation']['file_maxbytes']),
      :svlogd_num  => ( params[:svlogd_num] || node['private_chef'][component]['log_rotation']['num_to_keep'])
    )
  end

  if (params[:ha].nil? ? node['private_chef'][component]['ha'] : params[:ha])
    log "bring runit_service[#{component}] down" do
      notifies :down, "runit_service[#{component}]", :immediately
    end
  end

  # idempotent and needed on upgrade
  #if node['private_chef']['bootstrap']['enable']
    log "enable runit_service[#{component}]" do
      notifies :enable, "runit_service[#{component}]", :immediately
    end
  #end

end
