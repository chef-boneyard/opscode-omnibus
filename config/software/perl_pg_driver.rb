#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "perl_pg_driver"
default_version "3.3.0"

dependency "perl"
dependency "cpanminus"
dependency "postgresql92" # only because we're compiling DBD::Pg here, too.

source url: "http://search.cpan.org/CPAN/authors/id/T/TU/TURNSTEP/DBD-Pg-#{version}.tar.gz",
       md5: "547de1382a47d66872912fe64282ff55"

relative_path "DBD-Pg-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "cpanm -v --notest .", env: env
end
