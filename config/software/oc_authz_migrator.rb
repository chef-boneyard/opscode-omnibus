#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "oc_authz_migrator"
default_version "0.0.2"

dependency "erlang_r15"
dependency "rebar"

source git: "git@github.com:opscode/oc_authz_migrator"

relative_path "oc_authz_migrator"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Include the erlang_r15 bin
  env['PATH'] = "#{install_dir}/embedded/erlang_r15/bin:#{env['PATH']}"

  make "distclean", env: env
  make "compile", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/oc_authz_migrator/", exclude: ['**/.git', '**/.gitignore']
end
