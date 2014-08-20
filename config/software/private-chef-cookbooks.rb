#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "private-chef-cookbooks"

dependency "berkshelf2"
dependency "uuidtools"

source path: "#{project.resources_path}/#{name}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  mkdir "#{install_dir}/embedded/cookbooks"

  # Install the cookbooks
  command "#{install_dir}/embedded/bin/berks install" \
          " --berksfile=#{project_dir}/private-chef/Berksfile" \
          " --path=#{install_dir}/embedded/cookbooks", env: env

  block do
    File.open("#{install_dir}/embedded/cookbooks/dna.json", "w") do |f|
      f.write JSON.fast_generate(
        run_list: [
          'recipe[private-chef::default]',
        ]
      )
    end

    File.open("#{install_dir}/embedded/cookbooks/show-config.json", "w") do |f|
      f.write JSON.fast_generate(
        run_list: [
          'recipe[private-chef::show_config]',
        ]
      )
    end

    File.open("#{install_dir}/embedded/cookbooks/post_upgrade_cleanup.json", "w") do |f|
      f.write JSON.fast_generate(
        run_list: [
          "recipe[private-chef::post_11_upgrade_cleanup]",
          "recipe[private-chef::post_12_upgrade_cleanup]",
        ]
      )
    end

    File.open("#{install_dir}/embedded/cookbooks/solo.rb", "w") do |f|
      f.write <<-EOH.gsub(/^ {8}/, '')
        cookbook_path   "#{install_dir}/embedded/cookbooks"
        file_cache_path "#{install_dir}/embedded/cookbooks/cache"
        verbose_logging true
      EOH
    end
  end
end
