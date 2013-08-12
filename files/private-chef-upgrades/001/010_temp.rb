# This is purely a temporary workaround.  The erchef we're using still
# uses fast_log; if you change the size of the log file in the
# configuration **without also issuing a call to a
# disk_log:change_size/?** then the system *won't start*.  If you
# remove the log's *.siz file, though, everything's OK.
#
# We're going to ship a more recent version of Erchef that has
# fast_log completely removed, but that work isn't quite done yet;
# thus, this gimpy "upgrade" script.

define_upgrade do
  run_command("rm /var/log/opscode/opscode-erchef/erchef.log.siz")
  run_command("rm /var/log/opscode/opscode-erchef/requests.log.siz")
  restart_service "opscode-erchef"
end
