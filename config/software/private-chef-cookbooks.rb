name "private-chef-cookbooks"

dependency "rsync"

source :path => File.expand_path("files/private-chef-cookbooks", Omnibus.project_root)

build do
  gem "install uuidtools --no-rdoc --no-ri -v 2.1.3"
  command "mkdir -p #{install_dir}/embedded/cookbooks"
  command "#{install_dir}/embedded/bin/rsync --delete -a ./ #{install_dir}/embedded/cookbooks/"
end
