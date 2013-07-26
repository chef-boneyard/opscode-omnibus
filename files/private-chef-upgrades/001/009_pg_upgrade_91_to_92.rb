# Upgrading from postgresql 9.1 to 9.2 requires data migration.
define_upgrade do
  run_command("/opt/opscode/embedded/bin/pg_upgrade.sh")
end
