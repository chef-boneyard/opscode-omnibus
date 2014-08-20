#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-platform-debug"
default_version "rel-0.5.1"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"

source git: "git@github.com:opscode/opscode-platform-debug"

relative_path "opscode-platform-debug"

bundle_path = "#{install_dir}/embedded/service/gem"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{bundle_path}'", cwd: "#{project_dir}/orgmapper", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/opscode-platform-debug/", exclude: ['**/.git', '**/.gitignore']

  # Cleanup the .git directories in the bundle path before commiting them as\
  # submodules to the git cache.
  command "find #{bundle_path} -type d -name .git | xargs rm -rf"
end
