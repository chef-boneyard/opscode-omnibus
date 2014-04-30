name "private-chef"
maintainer 'Opscode, Inc.'
homepage 'http://www.opscode.com'

replaces        "private-chef-full"
install_path    "/opt/opscode"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# overrides
override :bzip2, version: "1.0.6"
override :cacerts, version: "2014.04.22"
override :couchdb, version: "1.0.3"
override :curl, version: "7.36.0"
override :gdbm, version: "1.9.1"
override :libffi, version: "3.0.13"
override :postgresql, version: "9.1.9"
override :python, version: "2.7.5"
override :ruby, version: "1.9.3-p484"
override :setuptools, version: "0.7.7"
override :util-macros, version: "1.18.0"
override :xproto, version: "7.0.25"

# global
dependency "preparation" # creates required build directories
dependency "chef-gem" # for embedded chef-solo
dependency "private-chef-cookbooks" # used by private-chef-ctl reconfigure
dependency "private-chef-scripts" # assorted scripts used by installed instance
dependency "private-chef-ctl" # additional project-specific private-chef-ctl subcommands
dependency "private-chef-administration"
dependency "nginx"
dependency "runit"
dependency "unicorn"

# the backend
dependency "couchdb"
dependency "postgresql"
dependency "redis"
dependency "rabbitmq"
dependency "opscode-solr"
dependency "opscode-expander"
dependency "chef-sql-schema" # needed to migrate the DB.
dependency "keepalived"
dependency "bookshelf"

# the front-end services
dependency "oc_erchef"
dependency "opscode-chef"
dependency "opscode-account"
dependency "opscode-webui"
dependency "opscode-authz"
dependency "opscode-org-creator"
dependency "opscode-certificate"
dependency "opscode-platform-debug"
dependency "opscode-test"
dependency "mysql2"

# monitoring
dependency "nagios"
dependency "nagios-plugins"
dependency "opscode-nagios-plugins"
dependency "nrpe"

# oc-chef-pedant for integration/smoke testing
dependency "oc-chef-pedant"

# partybus and upgrade scripts
dependency "partybus"
dependency "private-chef-upgrades"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
