name "opscode-org-creator"
default_version "rel-1.1.1"

dependency "erlang"
dependency "rebar"
dependency "rsync"

source :git => "git@github.com:opscode/opscode-org-creator"

relative_path "opscode-org-creator"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  # TODO: we need to get the app.config file there before we build ...
  # or do we?
  command "make rel", :env => env
  command "mkdir -p #{install_path}/embedded/service/opscode-org-creator"
  command "#{install_path}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_path}/embedded/service/opscode-org-creator/"
  command "rm -rf #{install_path}/embedded/service/opscode-org-creator/rel/org_app/log"
end
