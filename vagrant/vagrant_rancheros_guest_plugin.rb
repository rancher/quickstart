require 'ipaddr'

## Hacking this until we get a real plugin

# Borrowing from http://stackoverflow.com/questions/1825928/netmask-to-cidr-in-ruby
IPAddr.class_eval do
  def to_cidr
    self.to_i.to_s(2).count("1")
  end
end

module VagrantPlugins
  module GuestRancherOS
    class Guest < Vagrant.plugin("2", :guest)
      # Name used for guest detection
      GUEST_DETECTION_NAME = "rancheros".freeze

      def detect?(machine)
        machine.communicate.test <<-EOH.gsub(/^ */, '')
          if test -r /etc/os-release; then
            source /etc/os-release && test x#{self.class.const_get(:GUEST_DETECTION_NAME)} = x$ID && exit
          fi
          if test -x /usr/bin/lsb_release; then
            /usr/bin/lsb_release -i 2>/dev/null | grep -qi #{self.class.const_get(:GUEST_DETECTION_NAME)} && exit
          fi
          if test -r /etc/issue; then
            cat /etc/issue | grep -qi #{self.class.const_get(:GUEST_DETECTION_NAME)} && exit
          fi
          exit 1
        EOH
      end
    end
  end
end


module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") do
        Cap::ChangeHostName
      end

      guest_capability("linux", "configure_networks") do
        Cap::ConfigureNetworks
      end
    end
  end
end

module VagrantPlugins
    module GuestLinux
        module Cap
            class ConfigureNetworks
                def self.configure_networks(machine, networks)
                    machine.communicate.tap do |comm|
                        interfaces = []
                        comm.sudo("ip link show|grep eth[1-9]|awk '{print $2}'|sed -e 's/:$//'") do |_, result|
                            interfaces = result.split("\n")
                        end

                        networks.each do |network|
                            dhcp = "true"
                            iface = interfaces[network[:interface].to_i - 1]

                            if network[:type] == :static
                                cidr = IPAddr.new(network[:netmask]).to_cidr
                                comm.sudo("ros config set rancher.network.interfaces.#{iface}.address #{network[:ip]}/#{cidr}")
                                comm.sudo("ros config set rancher.network.interfaces.#{iface}.match #{iface}")

                                dhcp = "false"
                            end
                            comm.sudo("ros config set rancher.network.interfaces.#{iface}.dhcp #{dhcp}")
                        end

                        # Configure the default NAT interface
                        comm.sudo("ros config set rancher.network.interfaces.eth0.dhcp true")
                        comm.sudo("ros config set rancher.network.interfaces.eth0.match eth0")
                        comm.sudo("system-docker restart network")
                    end
                end
            end
        end
    end
end

module VagrantPlugins
    module GuestLinux
        module Cap
            class ChangeHostName
                def self.change_host_name(machine, name)
                    machine.communicate.tap do |comm|
                        if !comm.test("sudo hostname --fqdn | grep '#{name}'")
                            comm.sudo("ros config set hostname #{name}")
                        end
                    end
                end
            end
        end
    end
end
