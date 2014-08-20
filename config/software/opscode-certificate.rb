#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-certificate"
default_version "rel-0.1.4"

dependency "erlang_r15"

source git: "git@github.com:opscode/opscode-cert-erlang"

relative_path "opscode-certificate"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Include the erlang_r15 bin
  env['PATH'] = "#{install_dir}/embedded/erlang_r15/bin:#{env['PATH']}"

  make "clean", env: env
  make env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-certificate/", exclude: ['**/.git', '**/.gitignore']
end
