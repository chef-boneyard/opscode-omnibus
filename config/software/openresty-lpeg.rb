#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "openresty-lpeg"
default_version "0.12"

dependency "openresty"

source url: "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-#{version}.tar.gz",
       md5: "4abb3c28cd8b6565c6a65e88f06c9162"

relative_path "lpeg-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "LUADIR='#{install_dir}/embedded/luajit/include/luajit-2.0'", env: env
  command "install -p -m 0755 lpeg.so #{install_dir}/embedded/lualib", env: env
end
