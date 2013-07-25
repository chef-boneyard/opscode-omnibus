# Upgrading from postgresql 9.1 to 9.2 requires data migration.
define_upgrade do
  # move data dir to 9.1 backup
  run_command("mkdir -p /var/opt/opscode/postgresql91")
  run_command("mv /var/opt/opscode/postgresql/data /var/opt/opscode/postgresql91/")

  # initdb new data dir
  run_command("mkdir -p /var/opt/opscode/postgresql/data")
  run_command("sudo -H -u opscode-pgsql /opt/opscode/embedded/bin/initdb -D /var/opt/opscode/postgresql/data")
  run_command("cp /var/opt/opscode/postgresql91/postgresql.conf /var/opt/opscode/postgresql/data/")
  
  # pg_upgrade old 9.1 data to new data
  run_command("sudo -H -u opscode-pgsql /usr/lib/postgresql/9.2/bin/pg_upgrade -b /opt/opscode/embedded/lib/postgresql91/bin -B /opt/opscode/embedded/bin -d /var/opt/opscode/postgresql91/data -D /var/opt/opscode/postgresql/data -o ' -c config_file=/var/opt/opscode/postgresql91/data/postgresql.conf' -O ' -c config_file=/var/opt/opscode/postgresql/data/postgresql.conf'")
end
