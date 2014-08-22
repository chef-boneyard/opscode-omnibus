#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "oc-chef-pedant"
default_version "1.0.54"

dependency "ruby"
dependency "bundler"

source git: "git@github.com:opscode/oc-chef-pedant.git"

relative_path "oc-chef-pedant"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  bundle "install" \
         " --path '#{install_dir}/embedded/service/gem'", env: env

  sync "#{project_dir}", "#{install_dir}/embedded/service/oc-chef-pedant/", exclude: ['**/.git', '**/.gitignore']

  # Cleanup the .git directories in the bundle path before commiting them as
  # submodules to the git cache.
  required_files = %w(HEAD description hooks info objects refs)

  Dir.glob("#{install_dir}/**/config").reject { |path|
    required_files.any? { |required_file|
      !File.exists? File.join(File.dirname(path), required_file)
    }
  }.each { |path|
    FileUtils.rm_rf File.dirname(path)
  }
end
