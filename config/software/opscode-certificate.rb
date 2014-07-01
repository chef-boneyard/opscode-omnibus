name "opscode-certificate"
default_version "rel-0.1.4"

dependency "erlang"
dependency "rsync"

source :git => "git@github.com:opscode/opscode-cert-erlang"

relative_path "opscode-certificate"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  # TODO: we need to get the app.config file there before we build ...
  # or do we?
  command "make clean", :env => env
  command "make", :env => env
  command "mkdir -p #{install_path}/embedded/service/opscode-certificate"
  command "#{install_path}/embedded/bin/rsync -a --exclude=.git/*** --exclude=.gitignore ./ #{install_path}/embedded/service/opscode-certificate/"
end
