#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "private-chef-upgrades"

source path: "#{project.resources_path}/#{name}"

build do
  sync "#{project_dir}", "#{install_dir}/embedded/upgrades/", exclude: ['**/.git', '**/.gitignore']
end
