#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "postgresql91"
default_version "9.1.9"

dependency "zlib"
dependency "openssl"
dependency "libedit"
dependency "ncurses"

source :url => "http://ftp.postgresql.org/pub/source/v9.1.9/postgresql-9.1.9.tar.bz2",
       :md5 => "6b5ea53dde48fcd79acfc8c196b83535"

relative_path "postgresql-9.1.9"

configure_env = {
  "LDFLAGS" => "-Wl,-rpath,#{install_path}/embedded/lib,-rpath,#{install_path}/embedded/postgresql/9.1/lib -L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command ["./configure",
           "--prefix=#{install_path}/embedded/postgresql/9.1",
           "--with-libedit-preferred",
           "--with-openssl",
           "--with-includes=#{install_path}/embedded/include",
           "--with-libraries=#{install_path}/embedded/lib"].join(" "), :env => configure_env
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_path}/embedded/lib"}
  command "make install"
end
