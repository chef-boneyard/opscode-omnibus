#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "private-chef-scripts"

source path: "#{project.resources_path}/#{name}"

build do
  # Copy every script from inside the repo into the bindir.
  block do
    Dir.glob("#{project_dir}/*").each do |script|
      FileUtils.cp(script, "#{install_dir}/bin/")
    end
  end
end
