define_upgrade do
  upgrade_schema_to 25
  restart_service "postgres"
end
