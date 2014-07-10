name "oc_authz_migrator"
default_version "0.0.2"

dependency 'erlang'
dependency 'rebar'
dependency 'rsync'

source :git => "git@github.com:opscode/oc_authz_migrator"

relative_path "oc_authz_migrator"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command "make distclean", :env => env
  command "make compile", :env => env
  command "mkdir -p #{install_path}/embedded/service/oc_authz_migrator"
  command "#{install_path}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore . #{install_path}/embedded/service/oc_authz_migrator/"
end
