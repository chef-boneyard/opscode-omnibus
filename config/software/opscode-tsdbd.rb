name "opscode-tsdbd"
version "v0.0.2"

dependencies ["erlang", "rebar", "rsync"]

source :git => "git@github.com:opscode/opscode-tsdbd"

relative_path "opscode-tsdbd"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  "LD_FLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "make distclean", :env => env
  command "make rel", :env => env
  command "mkdir -p #{install_dir}/embedded/service/opscode-tsdbd"
  command "#{install_dir}/embedded/bin/rsync -a --delete ./rel/tsdbd/ #{install_dir}/embedded/service/opscode-tsdbd/"
  command "rm -rf #{install_dir}/embedded/service/opscode-tsdbd/log"
end
