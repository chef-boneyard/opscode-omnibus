#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "libossp-uuid"
default_version "1.6.2"

dependency "autoconf"
dependency "automake"

source url: "ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz",
       md5: "5db0d43a9022a6ebbbc25337ae28942f"

relative_path "uuid-1.6.2"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
