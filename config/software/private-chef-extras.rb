name "private-chef-extras"

dependency "rsync"

source :path => File.expand_path("files/private-chef-extras", Config.project_root)

build do
  command "mkdir -p #{install_dir}/embedded/extra"
  command "#{install_dir}/embedded/bin/rsync -a ./ #{install_dir}/embedded/extra"
end
