name "chef-sql-schema"
version "pc-rel-1.13.0"

dependency "ruby"
dependency "bundler"
dependency "postgresql92"
dependency "rsync"

source :git => "git@github.com:opscode/chef-sql-schema.git"

relative_path "chef-sql-schema"

# Need to add PG path to ENV
# TODO: should we just update the ENV in the postgresql.rb instead?
env = ENV.to_hash
env['PATH'] = "#{install_dir}/embedded/postgres/9.2:#{ENV['PATH']}"

build do
  bundle "install --without mysql --path=/opt/opscode/embedded/service/gem", :env => env
  command "mkdir -p #{install_dir}/embedded/service/chef-sql-schema"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/embedded/service/chef-sql-schema/"
end
