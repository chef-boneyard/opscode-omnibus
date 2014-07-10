name "oc_bifrost"
default_version "1.4.4"

dependency 'erlang'
dependency 'rebar'
dependency 'rsync'
dependency 'sqitch'

source :git => "git@github.com:opscode/oc_bifrost"

relative_path "oc_bifrost"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command "make distclean", :env => env
  command "make rel", :env => env
  command "mkdir -p #{install_path}/embedded/service/oc_bifrost"
  command "#{install_path}/embedded/bin/rsync -a --delete ./rel/oc_bifrost/ #{install_path}/embedded/service/oc_bifrost/"
  # TODO: git cleanup in oc_bifrost service directory
  command "rm -rf #{install_path}/embedded/service/oc_bifrost/log"
  command "#{install_path}/embedded/bin/rsync -a --delete ./schema/ #{install_path}/embedded/service/oc_bifrost/db/"
end
