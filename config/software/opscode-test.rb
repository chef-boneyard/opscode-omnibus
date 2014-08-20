#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-test"
default_version "0.3.2"

dependency "ruby"
dependency "libxml2"
dependency "bundler"
dependency "postgresql92"

source git: "git@github.com:opscode/opscode-test"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{install_dir}/embedded/service/gem'" \
         " --without dev", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-test/", exclude: ['**/.git', '**/.gitignore']

  # Cleanup the .git directories in the bundle path before commiting them as
  # submodules to the git cache.
  command "find #{install_dir}/embedded/service/gem -type d -name .git | xargs rm -rf"
end
