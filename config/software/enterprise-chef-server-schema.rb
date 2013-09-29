name "enterprise-chef-server-schema"
version "2.0.1"

source :git => "git@github.com:opscode/enterprise-chef-server-schema.git"

dependency "sqitch"

build do
  command "make install"
  command "mkdir -p #{install_dir}/embedded/service/#{name}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/embedded/service/#{name}/"
end
