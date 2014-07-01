name "oc_erchef"
default_version "0.25.14"

dependency "erlang"
dependency "rebar"
dependency "rsync"
dependency "gecode"

# RUBY DEPSOLVER - REMOVE FOR ROLLBACK #
dependency "ruby"
dependency "bundler"
# END RUBY DEPSOLVER #

source :git => "git@github.com:opscode/oc_erchef"

relative_path "oc_erchef"

env = {
  "PATH" => "#{install_path}/embedded/bin:#{ENV["PATH"]}",
  "LDFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "CFLAGS" => "-L#{install_path}/embedded/lib -I#{install_path}/embedded/include",
  "LD_RUN_PATH" => "#{install_path}/embedded/lib"
}

build do
  command "make distclean", :env => env
  ## RUBY DEPSOLVER - REMOVE BUNDLER_BUSTER FOR ROLLBACK ##
  # Omnibus is run from within bunlder. Applications running from within
  # bundler have environment variables set that effect the sub-execution
  # of ruby code, especially instances of bundler. To install the ruby
  # based depsolver, the oc_erchef Makefile executes bundler to package
  # the application and its dependencies. For this not to effect the
  # ruby environment from which we run omnbius, we must clear the
  # currently set bundler environment variables. BUNDLER BUSTER does this.
  command "make rel", :env => env.merge(Omnibus::Builder::BUNDLER_BUSTER)
  command "mkdir -p #{install_path}/embedded/service/opscode-erchef"
  command "#{install_path}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./rel/oc_erchef/ #{install_path}/embedded/service/opscode-erchef/"
  # TODO: git cleanup in opscode-erchef service directory
  command "rm -rf #{install_path}/embedded/service/opscode-erchef/log"
end
