#!/bin/bash
#
# Upgrades an OPC install from pg 9.1 to 9.2.
#
# Should be idempotent.
#

set -e # exit on error


EMBEDDED=/opt/opscode/embedded

PG_USER=opscode-pgsql
PG_BIN=$EMBEDDED/bin
PG_VAR=/var/opt/opscode/postgresql
PG_DATA=$PG_VAR/data
PG_MIGRATION=$PG_VAR/migration

PG91_BIN=$EMBEDDED/lib/postgresql91/bin
PG91_VAR=/var/opt/opscode/postgresql91


# make sure postgres is shut down
private-chef-ctl stop postgresql

# move data dir to 9.1 backup
if [ ! -d $PG91_VAR/data ]; then
  mkdir -p $PG91_VAR
  mv $PG_DATA $PG91_VAR/
fi

# new data dir
if [ ! -d $PG_DATA ]; then
  mkdir -p $PG_DATA
  chown $PG_USER $PG_DATA
fi

if [ ! -f $PG_DATA/postgresql.conf ]; then
  # needs --locale C because previous version DB uses that
  sudo -H -u $PG_USER $PG_BIN/initdb -D $PG_DATA --locale C
  cp $PG91_VAR/data/postgresql.conf $PG_DATA
fi

# pg_upgrade old 9.1 data to new data
# TODO: how to make idempotent?
if [ ! -f $PG_MIGRATION/migration.log ]; then
  mkdir -p $PG_MIGRATION
  chown $PG_USER $PG_MIGRATION
  cd $PG_MIGRATION
  sudo -H -u $PG_USER $PG_BIN/pg_upgrade \
    -b $PG91_BIN -B $PG_BIN \
    -d $PG91_VAR/data -D $PG_DATA \
    -o " -c config_file=$PG91_VAR/data/postgresql.conf" \
    -O " -c config_file=$PG_DATA/postgresql.conf" && date > migration.log
fi
