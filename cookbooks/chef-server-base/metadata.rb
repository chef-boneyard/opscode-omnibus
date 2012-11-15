maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Base Chef Server dependencies"
version           "0.10.0"

%w{ ubuntu }.each do |os|
  supports os
end
