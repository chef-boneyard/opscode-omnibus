#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "partybus"

dependency "bundler"
dependency "postgresql92"

source path: "#{project.resources_path}/#{name}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{install_dir}/embedded/service/gem'" \
         " --without mysql", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/partybus", exclude: ['**/.git', '**/.gitignore']
end
