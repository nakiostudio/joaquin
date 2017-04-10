module Joaquin
  class Job

    attr_accessor :job_id, :type, :first_step, :env, :status

    def initialize(json)
      @job_id = json['job_id']
      @type = json['type']
      @env = json['env'] || []
      @status = Joaquin::STATUS_UNSTARTED

      # Create steps and link in order
      previous_step = nil
      json['steps'].each do |step_json|
        step = Step.new(@job_id, step_json)
        if previous_step.nil?
          @first_step = step
        else
          previous_step.next_step = step
        end
        previous_step = step
      end
    end

    def run(&completion)
      weak_self = WeakRef.new(self)

      # Skip if job has already been started
      unless @status == Joaquin::STATUS_UNSTARTED
        Print.error("Trying to rerun started job with id #{@job_id.magenta}")
        completion.call(weak_self)
      end

      # Set environment variables
      @env.each do |key, value|
        ENV[key] = value
      end

      # Run steps
      @status = Joaquin::STATUS_STARTED
      Print.warning("Running job with id #{@job_id.magenta}...")
      step_completion = lambda do |step|
        if step.status == Joaquin::STATUS_SUCCESSFUL
          unless step.next_step.nil?
            step.next_step.run(step_completion)
          else
            weak_self.status = Joaquin::STATUS_SUCCESSFUL
            Print.success("Job with id #{weak_self.job_id.magenta} finished with status #{weak_self.status.magenta}")
            Job.submit_job_update(weak_self)
            completion.call(weak_self)
          end
        elsif step.status == Joaquin::STATUS_FAILED
          weak_self.status = Joaquin::STATUS_FAILED
          Print.warning("Job with id #{weak_self.job_id.magenta} finished with status #{weak_self.status.magenta}")
          Job.submit_job_update(weak_self)
          completion.call(weak_self)
        end
      end

      @first_step.run(step_completion)
    end

    def cancel
      @status = Joaquin::STATUS_CANCELLED
      Job.submit_job_update(self)
    end

    def self.submit_job_update(job)
      Print.debug("Updating remote status (#{job.status.magenta}) for job with id #{job.job_id.magenta}")
      Api.shared.submit_job_update(job)
    end

  end
end
