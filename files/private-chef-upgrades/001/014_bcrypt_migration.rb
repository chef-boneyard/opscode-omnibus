define_upgrade do

  if Partybus.config.bootstrap_server

    must_be_data_master

    # Restart chef-mover for the duration of the migration
    run_command("private-chef-ctl restart opscode-chef-mover")
    sleep(60)

    # Perform the actual migration
    run_command("/opt/opscode/embedded/bin/escript /opt/opscode/embedded/service/opscode-chef-mover/scripts/migrate-to-bcrypt-users")
  end
end
