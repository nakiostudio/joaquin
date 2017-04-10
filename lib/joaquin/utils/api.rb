require 'net/http'
require 'json'

module Joaquin
  class Api

    @@shared = Api.new

    attr_accessor :base_uri

    def initialize()
      @base_uri = URI(Joaquin.options.server_url)
    end

    def register_node(&completion)
      parameters = {}
      self.post('/node_api/node/register', parameters, completion)
    end

    def submit_job_update(job)
      parameters = {
        job_id: job.job_id,
        status: job.status
      }
      self.post('/node_api/job/update', parameters, nil)
    end

    def submit_step_update(step)
      parameters = {
        job_id: step.job_id,
        step_id: step.step_id,
        status: step.status
      }
      self.post('/node_api/step/update', parameters, nil)
    end

    def submit_log(step, type, line)
      parameters = {
        job_id: step.job_id,
        step_id: step.step_id,
        new_line: {
          type: type,
          string: line
        }
      }
      self.post('/node_api/step/log', parameters, nil)
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
