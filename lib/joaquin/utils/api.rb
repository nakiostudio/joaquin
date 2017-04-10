require 'net/http'
require 'json'

module Joaquin
  class Api

    @@shared = nil

    attr_accessor :base_uri

    def initialize()
      @base_uri = URI(Joaquin.options.server_url)
    end

    # Static accessorts

    def self.shared
      return @@shared
    end

    def self.shared=(new_shared)
      @@shared = new_shared
    end

    # Public methods

    def register_node(node_info, &completion)
      parameters = node_info.hash
      post(NODE_ENDPOINT_REGISTER_NODE, parameters) do |response|
        completion.call(response)
      end
    end

    def submit_job_update(job)
      parameters = {
        job_id: job.job_id,
        status: job.status
      }
      post(NODE_ENDPOINT_SUBMIT_JOB_UPDATE, parameters)
    end

    def submit_step_update(step)
      parameters = {
        job_id: step.job_id,
        step_id: step.step_id,
        status: step.status
      }
      post(NODE_ENDPOINT_SUBMIT_STEP_UPDATE, parameters)
    end

    def submit_step_log(step, type, line)
      parameters = {
        job_id: step.job_id,
        step_id: step.step_id,
        new_line: {
          type: type,
          string: line
        }
      }
      post(NODE_ENDPOINT_SUBMIT_STEP_LOG, parameters)
    end

    private

    def post(path, parameters, &completion)
      uri = @base_uri.dup
      uri.path = path

      # Build request
      request = Net::HTTP::Post.new(uri)
      request.body = parameters.to_json

      # Set HTTP headers
      request['Content-Type'] = 'application/json'
      request['X-Joaquin-Node-Token'] = Joaquin.options.token

      # Perform request
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      # Notify result
      completion.call(response) unless completion.nil?
    end

  end
end
