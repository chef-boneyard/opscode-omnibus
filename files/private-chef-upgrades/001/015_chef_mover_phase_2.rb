# This is the chef-mover `phase_2_prep_migration` and `phase_2_migration`
# that migrates containers and groups from couchDB to postgreSQL

require 'time'

define_upgrade do
  if Partybus.config.bootstrap_server

    must_be_data_master

    # Shut down everything but couch & postgres
    down_services = ['nginx',
                     'opscode-org-creator',
                     'bookshelf',
                     'oc_bifrost',
                     'opscode-account',
                     'opscode-certificate',
                     'opscode-erchef',
                     'opscode-expander',
                     'opscode-expander-reindexer',
                     'opscode-solr',
                     'opscode-webui',
                     'opscode-rabbitmq']

    down_services.each{|s| run_command("private-chef-ctl stop #{s}")}

    # delete pre-created orgs
    run_command("/opt/opscode/embedded/bin/ruby scripts/delete-pre-created-orgs.rb /etc/opscode/orgmapper.conf all",
                :cwd => "/opt/opscode/embedded/service/opscode-platform-debug/orgmapper",
                :env => {"RUBYOPT" => "-I/opt/opscode/embedded/lib/ruby/gems/1.9.1/gems/bundler-1.1.5/lib"})

    # Move any mover log files from a previous run, if they exist.
    # The log message parser requires a "clean slate".
    current_time = Time.now.utc.iso8601
    mover_log_file_glob = "/var/log/opscode/opscode-chef-mover/console.log*"
    parsed_log_output = "/var/log/opscode/opscode-chef-mover/parsed_console.log"
    run_command("mkdir /var/log/opscode/opscode-chef-mover/#{current_time}")
    begin
      run_command("mv #{mover_log_file_glob} /var/log/opscode/opscode-chef-mover/#{current_time}")
    rescue
      log "No files found at #{mover_log_file_glob}. Moving on..."
    end

    begin
      run_command("mv #{parsed_log_output} /var/log/opscode/opscode-chef-mover/#{current_time}")
    rescue
      log "#{parsed_log_output} not found. Moving on..."
    end

    ####
    #### perform a migration similar to what we did for hosted chef following this plan
    #### github.com/opscode/chef-mover/blob/024875c5545a0e7fb62c0852d4498d2ab7dd1c1d/docs/phase-2-migration-plan.md
    ####

    # Bring up chef-mover for the duration of the migration
    log "Firing up chef-mover, this could take a minute..."
    run_command("private-chef-ctl restart opscode-chef-mover")
    sleep(60)

    # Reload the account dets
    log "Loading data..."
    run_command("/opt/opscode/embedded/bin/escript /opt/opscode/embedded/service/opscode-chef-mover/scripts/create_account_dets")

    # Restart chef-mover to load updated account dets
    log "Restarting chef-mover after loading data, this could take a minute..."
    run_command("private-chef-ctl restart opscode-chef-mover")
    sleep(60)

    # Run phase_2_prep_migration with a env sleep_time of 0 milliseconds.
    # This will put all orgs in into 'holding' state for phase_2_migration.
    log "Preping the migration of containers and groups..."
    run_command("/opt/opscode/embedded/bin/escript " \
                "/opt/opscode/embedded/service/opscode-chef-mover/scripts/phase_2_migrate phase_2_prep_migration 1 0")

    # Run phase_2_migration
    log "Migrating containers and groups..."
    run_command("/opt/opscode/embedded/bin/escript " \
                "/opt/opscode/embedded/service/opscode-chef-mover/scripts/phase_2_migrate phase_2_migration 8 5000")

    # We don't need chef-mover anymore
    run_command("private-chef-ctl stop opscode-chef-mover")

    # Bring everything back up
    log "Restarting chef services..."
    down_services.reverse.each{|s| run_command("private-chef-ctl start #{s}")}

    log "Containers and groups migration complete!"
  end
end
