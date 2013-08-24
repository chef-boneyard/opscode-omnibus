# Copyright (c) 2013 Opscode, Inc.
# All Rights Reserved

# Perform safe cleanup after old packages and services following a
# successful Private Chef upgrade.  Executables will have been removed
# from the package upgrade process, but old data, configuration, logs,
# directories, etc. can be left behind.

def whyrun_supported?
  true
end

use_inline_resources

action :clean do
  remove_service if new_resource.is_service
  remove_files
  remove_links
  remove_users
  remove_groups
  remove_directories
end

def remove_directory(dir)
  directory dir do
    action :delete
    recursive true
  end
end

def remove_directories
  new_resource.directories.each do |dir|
    remove_directory(dir)
  end
end

# Our runit services have a standardized structure; this ensures that
# we completely remove everything.
def remove_service
  unlink "#{new_resource.service_link_root}/#{new_resource.package}"
  unlink "#{new_resource.service_init_link_root}/#{new_resource.package}"
  remove_directory "#{new_resource.service_root}/#{new_resource.package}"
end

def remove_files
  new_resource.files.each do |f|
    file f do
      action :delete
      backup false # We're removing cruft from the system; we don't
                   # want to leave backup cruft
    end
  end
end

def unlink(l)
  link l do
    action :delete
  end
end

def remove_links
  new_resource.links.each do |l|
    unlink(l)
  end
end

def remove_users
  new_resource.users.each do |u|
    user u do
      action :remove
    end
  end
end

def remove_groups
  new_resource.groups.each do |g|
    group g do
      action :remove
    end
  end
end
