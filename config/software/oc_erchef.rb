#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "oc_erchef"
default_version "0.26.2"

dependency "erlang"
dependency "rebar"
dependency "gecode"

# RUBY DEPSOLVER - REMOVE FOR ROLLBACK #
dependency "ruby"
dependency "bundler"
# END RUBY DEPSOLVER #

source git: "git@github.com:opscode/oc_erchef"

relative_path "oc_erchef"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "distclean", env: env
  make "rel", env: env

  sync "#{project_dir}/rel/oc_erchef/", "#{install_dir}/embedded/service/opscode-erchef/", exclude: ['**/.git', '**/.gitignore']
  delete "#{install_dir}/embedded/service/opscode-erchef/log"
end
