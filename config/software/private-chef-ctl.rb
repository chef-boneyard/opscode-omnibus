name "private-chef-ctl"

dependency "rsync"
dependency "omnibus-ctl"

source :path => File.expand_path("files/private-chef-ctl-commands", Config.project_root)

build do
  block do
    open("#{install_path}/bin/private-chef-ctl", "w") do |file|
      file.print <<-EOH
#!/bin/bash
#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# All Rights Reserved
#

export SVWAIT=30

# Ensure the calling environment (disapproval look Bundler) does not infect our
# Ruby environment if private-chef-ctl is called from a Ruby script.
for ruby_env_var in RUBYOPT \\
                    BUNDLE_BIN_PATH \\
                    BUNDLE_GEMFILE \\
                    GEM_PATH \\
                    GEM_HOME
do
  unset $ruby_env_var
done

#{install_path}/embedded/bin/omnibus-ctl opscode #{install_path}/embedded/service/omnibus-ctl $@
       EOH
    end
  end

  command "chmod 755 #{install_path}/bin/private-chef-ctl"

  # additional omnibus-ctl commands
  command "#{install_path}/embedded/bin/rsync -a ./ #{install_path}/embedded/service/omnibus-ctl/"
end
