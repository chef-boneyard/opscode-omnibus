name "opscode-platform-debug"
default_version "rel-0.4.6"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"
dependency "rsync"

source :git => "git@github.com:opscode/opscode-platform-debug"

relative_path "opscode-platform-debug"

orgmapper_dir = "#{project_dir}/orgmapper"

# Since this project pulls in the pg gem (or depends on something that
# does) we need to have the pg_config binary on the PATH so the
# correct library and header locations can be found
env = {
  'PATH' => "#{install_path}/embedded/bin:#{ENV['PATH']}"
}

bundle_path = "#{install_path}/embedded/service/gem"

build do
  # bundle install orgmapper
  bundle "install --path=#{bundle_path}", :cwd => orgmapper_dir, :env => env
  command "mkdir -p #{install_path}/embedded/service/opscode-platform-debug"
  command "#{install_path}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_path}/embedded/service/opscode-platform-debug/"

  # cleanup the .git directories in the bundle path before commiting
  # them as submodules to the git cache
  command "find #{bundle_path} -type d -name .git | xargs rm -rf"
end
