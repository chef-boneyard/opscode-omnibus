#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "postgresql91"
default_version "9.1.9"

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"

source url: "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2",
       md5: "6b5ea53dde48fcd79acfc8c196b83535"

relative_path "postgresql-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded/postgresql/9.1" \
          " --with-libedit-preferred" \
          " --with-openssl" \
          " --with-includes=#{install_dir}/embedded/include" \
          " --with-libraries=#{install_dir}/embedded/lib", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
