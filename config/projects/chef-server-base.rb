name "chef-server-base"

replaces        "private-chef-full"
install_path    "/opt/opscode"
build_version   Omnibus::BuildVersion.full
build_iteration "1"
archive         true

# initialize the dependencies
deps = []

# global
deps << "rsync"
deps << "openssl"
deps << "nginx"
deps << "runit"
deps << "unicorn"

# the backend
deps << "couchdb"
deps << "postgresql"
deps << "redis"
deps << "ruby"
deps << "erlang"
deps << "rabbitmq"
deps << "opscode-solr"
deps << "chef-sql-schema" # needed to migrate the DB.
deps << "keepalived"
deps << "bookshelf"

# the front-end services
deps << "mysql2"

# monitoring
deps << "nagios"
deps << "nagios-plugins"

dependencies deps

exclude "\.git*"
exclude "bundler\/git"
