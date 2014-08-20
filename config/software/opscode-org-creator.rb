#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-org-creator"
default_version "rel-1.1.1"

dependency "erlang_r15"
dependency "rebar"

source git: "git@github.com:opscode/opscode-org-creator"

relative_path "opscode-org-creator"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Include the erlang_r15 bin
  env['PATH'] = "#{install_dir}/embedded/erlang_r15/bin:#{env['PATH']}"

  make "rel", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-org-creator/", exclude: ['**/.git', '**/.gitignore']
  delete "#{install_dir}/embedded/service/opscode-org-creator/rel/org_app/log"
end
