require 'sysinfo'

module Joaquin
  class NodeInfo

    attr_accessor :hash

    def initialize(host, port)
      sys_info = SysInfo.new
      @hash = {
        os: sys_info.os,
        arch: sys_info.arch,
        system: sysinfo.impl,
        local_host: "#{host}:#{port}",
        ip_address: sys_info.ipaddress_internal,
        port: port,
        shell: sys_info.shell,
        user: sys_info.user,
        home_dir: sys_info.home
      }
    end

    def set_public_host(host)
      @hash['public_host'] = host
    end

  end
end
