name "bookshelf"
default_version "1.1.3"

dependency "erlang"
dependency "rebar"
dependency "rsync"

source :git => "git://github.com/opscode/bookshelf.git"

relative_path "bookshelf"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command "make distclean", :env => env
  command "make rel", :env => env
  command "mkdir -p #{install_path}/embedded/service/bookshelf"
  command "#{install_path}/embedded/bin/rsync -a --delete ./rel/bookshelf/ #{install_path}/embedded/service/bookshelf/"
  command "rm -rf #{install_path}/embedded/service/bookshelf/log"
end
