#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "private-chef-ctl"

dependency "highline-gem"
dependency "omnibus-ctl"

source path: "#{project.resources_path}/#{name}"

build do
  erb source: "private-chef-ctl.erb",
      dest:   "#{install_dir}/bin/private-chef-ctl",
      mode:   0755,
      vars:   {
        embedded_bin: "#{install_dir}/embedded/bin",
        embedded_service: " #{install_dir}/embedded/service",
      }

  sync "#{project_dir}", "#{install_dir}/embedded/service/omnibus-ctl/", exclude: ['**/.git', '**/.gitignore']
end
