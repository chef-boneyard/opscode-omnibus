#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# All Rights Reserved
#

require 'highline/import'

add_command "password", "Set a user's password or System Recovery Password.", 2 do
  unless ARGV.length == 2 || (ARGV.length == 3 && ARGV[2] == "--disable")
    STDERR.puts "Usage: private-chef-ctl password <username> [--disable]"
    exit 1
  end

  load_running_config
  username = ARGV[1]
  superuser = running_config['private_chef']['opscode-account']['proxy_user']
  command = [
    'bundle', 'exec', 'bin/updateobjecttool',
    '-a', running_config['private_chef']['opscode-account']['url'],
    '-o', superuser,
    '-p', "/etc/opscode/#{superuser}.pem",
    '-w', 'user',
    '-n', username
  ]
  if ARGV.length == 2
    password = HighLine.ask("Enter the new password:  " ) { |q| q.echo = "*" }
    password2 = HighLine.ask("Enter the new password again:  " ) { |q| q.echo = "*" }
    if password != password2
      STDERR.puts "Passwords did not match"
      exit 1
    end
    if password == '' && ldap_authentication_enabled?
      STDERR.puts "Password may not be blank.  Did you mean 'private-chef-ctl password #{username} --disable'?"
      exit 1
    end

    command << '--user-password'
    command << password
    if ldap_authentication_enabled?
      command << '--recovery-authentication-enabled'
      verbed = 'enabled for System Recovery'
    else
      verbed = 'set'
    end
  else
    if ldap_authentication_enabled?
      command << '--no-recovery-authentication-enabled'
      verbed = 'disabled for System Recovery'
    else
      STDERR.puts "External authentication (such as LDAP) must be enabled to clear a user's password."
      exit 1
    end
  end

  ENV["PATH"] = "/opt/opscode/embedded/bin:#{ENV['PATH']}"
  Dir.chdir("/opt/opscode/embedded/service/opscode-account")
  if !run_command(*command)
    STDERR.puts "FAILED"
    exit $?.exitstatus
  end
  puts "Password for #{username} successfully #{verbed}."
end

# =============================================================================
# Private Script Functions
# =============================================================================

def ldap_authentication_enabled?
  running_config['private_chef']['ldap'] && !running_config['private_chef']['ldap'].empty?
end
