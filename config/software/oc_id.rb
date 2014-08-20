#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "oc_id"
default_version "0.3.3"

dependency "postgresql92" # for libpq
dependency "nodejs"
dependency "ruby"
dependency "bundler"

source git: "git@github.com:opscode/oc-id"

relative_path "oc-id"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{install_dir}/embedded/service/gem'" \
         " --without development test doc", env: env
  bundle "exec rake assets:precompile", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/oc_id/", exclude: ['**/.git', '**/.gitignore']
  delete "#{install_dir}/embedded/service/oc_id/log"
end
