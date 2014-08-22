#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-chef-mover"
default_version "2.2.10"

dependency "erlang"
dependency "rebar"

source git: "git@github.com:opscode/chef-mover"

relative_path "opscode-chef-mover"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "distclean", env: env
  make "rel", env: env

  sync "#{project_dir}/rel/mover/", "#{install_dir}/embedded/service/opscode-chef-mover/", exclude: ['**/.git', '**/.gitignore']
  delete "#{install_dir}/embedded/service/opscode-chef-mover/log"

  mkdir "#{install_dir}/embedded/service/opscode-chef-mover/scripts"

  copy "#{project_dir}/scripts/migrate", "#{install_dir}/embedded/service/opscode-chef-mover/scripts"
  command "chmod ugo+x #{install_dir}/embedded/service/opscode-chef-mover/scripts/migrate"

  copy "#{project_dir}/scripts/check_logs.rb", "#{install_dir}/embedded/service/opscode-chef-mover/scripts"
  command "chmod ugo+x #{install_dir}/embedded/service/opscode-chef-mover/scripts/check_logs.rb"
end
