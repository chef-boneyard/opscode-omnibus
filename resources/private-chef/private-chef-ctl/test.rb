#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
#
# All Rights Reserved
#

add_command "test", "Run the API test suite against localhost.", 2 do
  pedant_args = ARGV[3..-1]
  pedant_args = ["--smoke"] unless pedant_args.any?
  Dir.chdir(File.join(base_path, "embedded", "service", "oc-chef-pedant"))
  pedant_config = File.join(data_path, "oc-chef-pedant", "etc", "pedant_config.rb")
  bundle = File.join(base_path, "embedded", "bin", "bundle")
  status = run_command("#{bundle} exec ./bin/oc-chef-pedant -c #{pedant_config} #{pedant_args.join(' ')}")
  exit status.exitstatus
end
