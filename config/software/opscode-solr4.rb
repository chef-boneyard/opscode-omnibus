#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "opscode-solr4"
default_version "4.5.1"

dependency "server-jre"

source url: "http://www.dsgnwrld.com/am/lucene/solr/4.5.1/solr-#{version}.tgz",
       md5: "7c8c9fbbade5c119288b06c501fa46b2"

relative_path "solr-#{version}"

build do
  mkdir "#{install_dir}/embedded/service/opscode-solr4"

  # copy over the licenses
  copy "#{project_dir}/licenses/", "#{install_dir}/embedded/service/opscode-solr4/"
  copy "#{project_dir}/LICENSE.txt", "#{install_dir}/embedded/service/opscode-solr4/"
  copy "#{project_dir}/NOTICE.txt", "#{install_dir}/embedded/service/opscode-solr4/"

  # Clean up solr jetty and copy
  #
  # We'll remove all of the examples that ship with solr and build our own Solr
  # home with the Chef recipes
  mkdir "#{install_dir}/embedded/service/opscode-solr4/jetty"
  delete "#{project_dir}/example/example*"
  delete "#{project_dir}example/multicore"
  delete "#{project_dir}example/solr"
  sync "#{project_dir}/example/", "#{install_dir}/embedded/service/opscode-solr4/jetty/", exclude: ['**/.git', '**/.gitignore']
end
