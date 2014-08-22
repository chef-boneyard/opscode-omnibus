#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "oc_bifrost"
default_version "1.4.4"

dependency "erlang"
dependency "rebar"
dependency "sqitch"

source git: "git@github.com:opscode/oc_bifrost"

relative_path "oc_bifrost"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "distclean", env: env
  make "rel", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/oc_bifrost/", exclude: ['**/.git', '**/.gitignore']
  delete "#{install_dir}/embedded/service/oc_bifrost/log"

  # Schema - TODO: should this just be a symlink instead?
  sync "#{project_dir}/schema", "#{install_dir}/embedded/service/oc_bifrost/db/", exclude: ['**/.git', '**/.gitignore']
end
