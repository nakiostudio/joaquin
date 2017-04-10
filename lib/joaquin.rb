require 'commander'
require 'colorize'
require 'weakref'
require 'thread'
require 'joaquin/constants'
require 'joaquin/version'
require 'joaquin/utils/print'
require 'joaquin/utils/api'
require 'joaquin/utils/jobs_queue'
require 'joaquin/model/node_info'
require 'joaquin/model/step'
require 'joaquin/model/job'
require 'joaquin/node'

module Joaquin
  class << self

    include Commander::Methods

    attr_accessor :options

    def run
      program :name, 'Joaquin'
      program :version, Joaquin::VERSION
      program :description, Joaquin::DESCRIPTION
      program :help, 'Author', 'Carlos Vidal <nakioparkour@gmail.com>'

      command :'server install' do |c|
        c.syntax = 'server install'
        c.description = ''
        c.action do |args, options|
          Joaquin.options = options
          puts 'Installing server'
        end
      end

      command :'server run' do |c|
        c.syntax = 'server run'
        c.description = ''
        c.action do |args, options|
          Joaquin.options = options
          puts 'Running server'
        end
      end

      command :'node run' do |c|
        c.syntax = 'node run [options]'
        c.description = ''
        c.option '--server-url STRING', String, 'Url of the Joaquin server'
        c.option '--port STRING', String, 'Port the node will listen to. Default is 4567'
        c.option '--token STRING', String, 'Token used by the node to grant the incoming requests and sign the outcoming ones'
        c.option '--concurrent-jobs INTEGER', Integer, 'Maximum number of jobs that can run concurrently'
        c.option '--verbose', 'Increases the amount of information logged'
        c.action do |args, options|
          # Default options
          options.default \
            port: '4567',
            server_url: 'http://localhost:9001',
            jobs_directory: 'jobs',
            concurrent_jobs: 1,
            verbose: false

          # Set env variables
          ENV['PORT'] = options.port

          # Set options global attr
          Joaquin.options = options

          # Run node
          Node.start(options)
        end
      end
      run!
    end

  end
end
