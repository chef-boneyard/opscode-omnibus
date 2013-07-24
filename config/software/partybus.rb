name "partybus"

dependency "rsync"
dependency "bundler"
dependency "postgresql92"

source :path => File.expand_path("partybus", Omnibus.project_root)

# Need to add PG path to ENV
# TODO: should we just update the ENV in the postgresql.rb instead?
env = ENV.to_hash
env['PATH'] = "#{install_dir}/embedded/postgres/9.2:#{ENV['PATH']}"

build do
  command "mkdir -p #{install_dir}/embedded/service/partybus"
  bundle "install --without mysql --path=/opt/opscode/embedded/service/gem", :env => env
  command "#{install_dir}/embedded/bin/rsync --delete -a ./ #{install_dir}/embedded/service/partybus"
end
