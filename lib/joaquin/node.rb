require 'rack'
require 'webrick'
require 'json'

module Joaquin
  class Node

    @@queue = nil
    @@info = nil

    def self.call(request)
      # Validate
      if request['HTTP_JOAQUIN_SERVER_TOKEN'] != Joaquin.options.token
        return [401, {'Content-Type' => 'application/json'}, [{error: 'Invalid server token'}.to_json]]
      end

      # Otherwise handle request
      case request['REQUEST_PATH']
      when SERVER_ENDPOINT_NODE_STATUS
        # TODO return node status
      when SERVER_ENDPOINT_ENQUEUE_JOB
        # TODO add job to queue
      when SERVER_ENDPOINT_CANCEL_JOB
        # TODO cancel running job
      else
        return [404, {'Content-Type' => 'application/json'}, [{error: 'Resource could not be found'}.to_json]]
      end
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

        # Create node info object
        Node.info = NodeInfo.new(server.config[:BindAddress], server.config[:Port])

        # Create jobs queue
        Node.queue = JobsQueue.new(Joaquin.options.concurrent_jobs)

        # Subscribe to kill signal
        [:INT, :TERM].each do |signal| trap(signal) do
            Print.warning('Received signal, killing node...')
            Node.queue.cancel
            server.stop
          end
        end

        # Register node remotelly
        Node.register_node
      end
    end

    def self.tunnel_node
      # TODO: Start ngrok tunneling
    end

    def self.register_node
      Print.debug("Registering node at Joaquin server with address #{Joaquin.options.server_url.magenta}...")
      Api.shared.register_node(Node.info) do |response|
        if respose.code == 201
          Print.success('Successfully registered node')

          # Start queue loop
          Node.queue.resume
        else
          Print.error("Unable to register node at host provided with address #{Joaquin.options.server_url.magenta}")

          # Retry
          Print.info('Retrying node registration in 10 seconds...')
          sleep(10)
          Node.register_node
        end
      end
    end

  end
end
