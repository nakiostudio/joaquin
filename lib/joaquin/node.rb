require 'rack'
require 'webrick'
require 'json'

module Joaquin
  class Node

    @@jobs = {}

    def self.call(request)
      # Status
      # Run job
      # Cancel job
      # Job details
      [200, {'Content-Type' => 'application/json'}, [request.to_json]]
    end

    def self.start(options)
      rack_options = {
        Host: '127.0.0.1',
        Port: options.port,
        Logger: WEBrick::Log.new("/dev/null"),
        AccessLog: []
      }

      Print.warning("Booting up node at #{rack_options[:Host]}:#{rack_options[:Port]}...")
      Rack::Handler::WEBrick.run(Node, rack_options) do |server|
        Print.success("Node running at #{server.config[:BindAddress]}:#{server.config[:Port]}")
        [:INT, :TERM].each do |signal| trap(signal) do
            Print.warning('Received signal, killing node...')
            server.stop
          end
        end
      end
    end

    def self.tunnel_node
      # TODO: Start ngrok tunneling
    end

    def self.register_node
      # TODO: Register node remotelly
    end

  end
end
