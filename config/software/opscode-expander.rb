#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-expander"
default_version "pc-rel-1.0.0.1"

dependency "ruby"
dependency "bundler"

source git: "git@github.com:opscode/opscode-expander"

relative_path "opscode-expander"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '/opt/opscode/embedded/service/gem'", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-expander/", exclude: ['**/.git', '**/.gitignore']
end
