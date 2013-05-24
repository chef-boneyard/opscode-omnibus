#
# Author:: Nathan L Smith (<smith@opscode.com>)
# Copyright:: Copyright (c) 2013 Opscode, Inc.
#
# All Rights Reserved
#

%w[ opscode-webui2 opscode-webui2-events ].each do |service|
  runit_service service do
    action :disable
  end
end
