name "opscode-pushy"
version "master"

dependencies ["erlang",
              "rebar",
              "autoconf",
              "automake",
              "libtool",
              "rsync",
              "e2fsprogs"]

source :git => "git@github.com:opscode/opscode-pushy-server"

relative_path "opscode-pushy"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  # Pushy server
  command "make distclean", :env => env, :cwd => project_dir
  command "make rel", :env => env, :cwd => project_dir
  command "mkdir -p #{install_dir}/embedded/service/opscode-pushy"
  command "#{install_dir}/embedded/bin/rsync -a --delete ./rel/pushy/ #{install_dir}/embedded/service/opscode-pushy/", :cwd => project_dir
  command "rm -rf #{install_dir}/embedded/service/opscode-pushy/log"

  # Schema
  bundle "install --without mysql --path=/opt/opscode/embedded/service/gem", :cwd => "#{project_dir}/db"
  command "mkdir -p #{install_dir}/embedded/service/opscode-pushy/db"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./db/ #{install_dir}/embedded/service/opscode-pushy/db/"
end
