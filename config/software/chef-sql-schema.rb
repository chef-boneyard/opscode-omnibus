#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "chef-sql-schema"
default_version "pc-rel-1.16.0"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"

source git: "git@github.com:opscode/chef-sql-schema.git"

relative_path "chef-sql-schema"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '/opt/opscode/embedded/service/gem'", env: env

  sync  "#{project_dir}", "#{install_dir}/embedded/service/chef-sql-schema/", exclude: ['**/.git', '**/.gitignore']
end
