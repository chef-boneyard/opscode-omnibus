name "private-chef-cookbooks"

dependencies [ "rsync" ]

source :path => File.expand_path("files/private-chef-cookbooks", Omnibus.root)

build do
  command "mkdir -p #{install_dir}/embedded/cookbooks"
  command "#{install_dir}/embedded/bin/rsync --delete -a ./ #{install_dir}/embedded/cookbooks/"
end
