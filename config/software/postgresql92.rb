#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "postgresql92"
default_version "9.2.9"

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"
dependency "libossp-uuid"

source url: "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2",
       md5: "38b0937c86d537d5044c599273066cfc"

relative_path "postgresql-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded/postgresql/9.2" \
          " --with-libedit-preferred" \
          " --with-openssl" \
          " --with-ossp-uuid" \
          " --with-includes=#{install_dir}/embedded/include" \
          " --with-libraries=#{install_dir}/embedded/lib", env: env

  make "world -j #{max_build_jobs}", env: env
  make "install-world", env: env

  # Postgres 9.2 is our "real" Postgres installation (prior versions that are
  # installed are solely to facilitate upgrades). As a result, we need to have
  # the binaries for this version available with the other binaries used by
  # Private Chef.
  #
  # This must happen in a Ruby block or else the computation will happen at
  # load time instead of build time (and the files will not yet exist on disk).
  block do
    Dir.glob("#{install_dir}/embedded/postgresql/9.2/bin/*").each do |path|
      FileUtils.ln_s(path, "#{install_dir}/embedded/bin/#{File.basename(path)}")
    end
  end
end
