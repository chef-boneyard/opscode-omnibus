name "enterprise-chef-server-schema"
default_version "f6185e3a280446669b1b49d6c4420457a30a40ef"

source :git => "git@github.com:opscode/enterprise-chef-server-schema.git"

dependency "sqitch"

build do
  command "make install"
  command "mkdir -p #{install_dir}/embedded/service/#{name}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/embedded/service/#{name}/"
end
