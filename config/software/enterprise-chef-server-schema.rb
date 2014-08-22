#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "enterprise-chef-server-schema"
default_version "2.4.0"

source git: "git@github.com:opscode/enterprise-chef-server-schema.git"

dependency "sqitch"
dependency "perl_pg_driver"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "install", env: env
  sync  "#{project_dir}", "#{install_dir}/embedded/service/enterprise-chef-server-schema/", exclude: ['**/.git', '**/.gitignore']
end
