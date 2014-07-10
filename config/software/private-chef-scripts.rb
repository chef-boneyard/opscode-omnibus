name "private-chef-scripts"

dependency "rsync"

source :path => File.expand_path("files/private-chef-scripts", Config.project_root)

build do
  command "mkdir -p #{install_path}/embedded/bin"
  command "#{install_path}/embedded/bin/rsync -a ./ #{install_path}/bin/"
end
