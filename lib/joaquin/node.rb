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
      Rack::Handler::WEBrick.run(Node, rack_options) do |server|
        [:INT, :TERM].each { |sig| trap(sig) { server.stop } }
      end
    end

  end
end
