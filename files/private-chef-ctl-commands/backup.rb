require 'chef_backup'

add_command_under_category 'backup', 'general', 'Backup the Chef Server', 1 do
  unless running_config
    puts '[ERROR] cannot backup if you haven\'t completed a reconfigure'
    exit 1
  end
  status = ChefBackup::Runner.new(running_config).backup
  exit(status ? 0 : 1)
end
