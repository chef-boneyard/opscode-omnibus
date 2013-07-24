name "opscode-test"
version "0.3.0"

dependency "ruby"
dependency "libxml2"
dependency "rsync"
dependency "bundler"
dependency "postgresql92"

source :git => "git@github.com:opscode/opscode-test"

# Need to add PG path to ENV
# TODO: should we just update the ENV in the postgresql.rb instead?
env = ENV.to_hash
env['PATH'] = "#{install_dir}/embedded/postgres/9.2:#{ENV['PATH']}"

build do
  bundle "install --without mysql dev --path=/opt/opscode/embedded/service/gem", :env => env
  command "mkdir -p #{install_dir}/embedded/service/opscode-test"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/embedded/service/opscode-test/"
end
