name "opscode-account"
version "rel-1.32.1"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"
dependency "rsync"

source :git => "git@github.com:opscode/opscode-account"

relative_path "opscode-account"

# Need to add PG path to ENV
# TODO: should we just update the ENV in the postgresql.rb instead?
env = ENV.to_hash
env['PATH'] = "#{install_dir}/embedded/postgres/9.2:#{ENV['PATH']}"

build do
  bundle "install --without mysql test --path=/opt/opscode/embedded/service/gem", :env => env
  command "mkdir -p #{install_dir}/embedded/service/opscode-account"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/embedded/service/opscode-account/"
end
