#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "knife-ec-backup"
default_version "2.0.0.beta.2"

dependency "pg-gem"
dependency "sequel-gem"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Ignore dependencies, since they are already installed on the system by
  # omnibus from one of the dependencies. This ensures we can properly link the
  # pg to the needed headers without needing to pass options through
  # knife-ec-backup.
  gem "install knife-ec-backup" \
      " --version '#{version}'" \
      " --bindir '#{install_dir}/embedded/bin'" \
      " --ignore-dependencies" \
      " --no-ri --no-rdoc", env: env
end
