maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Base Chef Server dependencies"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.10.0"

%w{ ubuntu }.each do |os|
  supports os
end
