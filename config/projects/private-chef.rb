name "private-chef"

replaces        "private-chef-full"
install_path    "/opt/opscode"
build_version   Omnibus::BuildVersion.full
build_iteration "1"

# initialize the dependencies
deps = []

# global
deps << "chef-pc"
deps << "private-chef-cookbooks"
deps << "private-chef-administration"
deps << "private-chef-scripts"

# the backend
deps << "opscode-expander"
deps << "chef-sql-schema" # needed to migrate the DB.

# the front-end services
deps << "oc_erchef"
deps << "opscode-chef"
deps << "opscode-account"
deps << "opscode-webui"
deps << "opscode-authz"
deps << "opscode-org-creator"
deps << "opscode-certificate"
deps << "opscode-platform-debug"
deps << "opscode-test"

# monitoring
deps << "opscode-nagios-plugins"
deps << "nrpe"

# oc-chef-pedant for integration/smoke testing
deps << "oc-chef-pedant"

# partybus and upgrade scripts
deps << "partybus"
deps << "private-chef-upgrades"

# Version manifest file
deps << "pc-version"

dependencies deps

exclude "\.git*"
exclude "bundler\/git"
