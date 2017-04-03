require 'rack'

module Joaquin
  class Node

    def self.call(env)
      require 'pp'
      pp env
      [200, {'Content-Type' => 'text/html'}, ['derp']]
    end

    def self.start(options)
      # http://www.ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html
      rack_options = {
        Host: '127.0.0.1',
        Port: options.port
      }

      Print.warning("Booting up node at #{rack_options[:Host]}:#{rack_options[:Port]}...")
      Rack::Handler::WEBrick.run(Node, rack_options) do |server|
        [:INT, :TERM].each do |signal|
          trap(signal) do
            Print.warning('Received signal, killing node...')
            server.stop
          end
        end
      end
    end

  end
end
