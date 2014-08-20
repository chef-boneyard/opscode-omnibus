#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "bookshelf"
default_version "1.1.4"

dependency "erlang"
dependency "rebar"

source git: "git://github.com/opscode/bookshelf.git"

relative_path "bookshelf"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  make "distclean", env: env
  make "rel", env: env

  sync   "#{project_dir}/rel/bookshelf/", "#{install_dir}/embedded/service/bookshelf/"
  delete "#{install_dir}/embedded/service/bookshelf/log"
end
