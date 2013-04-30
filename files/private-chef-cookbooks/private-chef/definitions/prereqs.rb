#Two modes of usage: ports mode and regular mode
#Ports Mode:
#  The port attribute has a value consisting of an array of port numbers that we would like to see unused
#  The check attribute is set to true

#Regular Mode:
#  The check attribute is defined with whatever condition we would like to fail the p-c-c reconfigure
#

define :prereqs_check do

  ruby_block "#{params[:name]}" do
    block do
      message = ""
      banner = "\n\n*-*-* Prereqs Failed *-*-*\n\n"
      message << banner
      unless File.exists?("/var/opt/opscode/bootstrapped")
      unless params[:port].nil?
         inports = params[:port].to_a
         maskports = OmnibusHelper.ports_open?("127.0.0.1", inports)
         inports.reject! {|x| maskports.shift == false}
         unless inports.empty?
            message << "Port is in use: #{inports} "
            message << params[:message]
            Chef::Application.fatal!("--- #{message} --- ", 1)
            raise "#{message}"
         end
      end
    end
      message << params[:message]
      unless params[:check] == true
        Chef::Application.fatal!("--- #{message} --- ", 1)
        raise "#{message}"
      end
      end
    action :create
    only_if "#{params[:check]}"
  end

end
