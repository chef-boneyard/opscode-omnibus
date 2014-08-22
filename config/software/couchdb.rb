#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "couchdb"
default_version "1.0.3"

dependency "spidermonkey"
dependency "icu"
dependency "curl"
dependency "erlang_r15"

source url: "http://archive.apache.org/dist/couchdb/#{version}/apache-couchdb-#{version}.tar.gz",
       md5: "cfdc2ab751bf18049c5ef7866602d8ed"

relative_path "apache-couchdb-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    "RPATH" => "#{install_dir}/embedded/lib",
    "CURL_CONFIG" => "#{install_dir}/embedded/bin/curl-config",
    "ICU_CONFIG" => "#{install_dir}/embedded/bin/icu-config",
    "ERL" => "#{install_dir}/embedded/erlang_r15/bin/erl",
    "ERLC" => "#{install_dir}/embedded/erlang_r15/bin/erlc",
  )

  # Include the erlang_r15 bin
  env["PATH"] = "#{install_dir}/embedded/erlang_r15/bin:#{env['PATH']}"

  # WARNING - this is different! Someone with more time than me should figure
  # out why!
  env["CFLAGS"]  = "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include"
  env.delete("LDFLAGS")

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --disable-init" \
          " --disable-launchd" \
          " --with-erlang=#{install_dir}/embedded/erlang_r15/lib/erlang/usr/include" \
          " --with-js-include=#{install_dir}/embedded/include" \
           "--with-js-lib=#{install_dir}/embedded/lib", env: env

  make "-j #{workers}", env: env
  make "install", env: env
end
