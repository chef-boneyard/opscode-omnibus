name "private-chef-upgrades"

dependency "rsync"

source :path => File.expand_path("files/private-chef-upgrades", Config.project_root)

build do
  command "mkdir -p #{install_path}/embedded/upgrades"
  command "#{install_path}/embedded/bin/rsync --delete -a ./ #{install_path}/embedded/upgrades/"
end
