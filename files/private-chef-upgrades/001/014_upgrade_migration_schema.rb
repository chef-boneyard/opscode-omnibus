define_upgrade do

  if Partybus.config.bootstrap_server

    must_be_data_master

    # run 2.2.4 migration which includes schema upgrade for migration state
    run_command("sqitch --db-user opscode-pgsql deploy --to-target @2.2.4",
                :cwd => "/opt/opscode/embedded/service/enterprise-chef-server-schema")

  end
end
