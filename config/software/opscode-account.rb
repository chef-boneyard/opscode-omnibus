#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-account"
default_version "rel-1.51.0"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"

source git: "git@github.com:opscode/opscode-account"

relative_path "opscode-account"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{install_dir}/embedded/service/gem'" \
         " --without test", env: env

  mkdir "#{install_dir}/embedded/service/opscode-account"
  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-account/", exclude: ['**/.git', '**/.gitignore']

  # Cleanup the .git directories in the bundle path before commiting them as
  # submodules to the git cache.
  command "find #{install_dir}/embedded/service/gem -type d -name .git | xargs rm -rf"
end
