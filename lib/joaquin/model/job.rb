module Joaquin
  class Job

    attr_accessor :job_id, :type, :first_step, :env, :status

    def initialize(json)
      @job_id = json['job_id']
      @type = json['type']
      @env = json['env']
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
      unless @status == Joaquin::STATUS_UNSTARTED
        Print.error("Trying to rerun started job with id #{@job_id.magenta}")
        completion.call(weak_self)
      end

      # TODO: Set env variables

      @status = Joaquin::STATUS_STARTED
      Print.debug("Running job with id #{@job_id.magenta}...")
      completion = lambda do |step|
        if step.status == Joaquin::STATUS_SUCCESSFUL
          unless step.next_step.nil?
            step.next_step.run(completion)
          else
            weak_self.status = Joaquin::STATUS_SUCCESSFUL
            Print.debug("Job with id #{weak_self.job_id.magenta} finished with status #{weak_self.status.magenta}")
            Job.submit_job_update(weak_self)
            completion.call(weak_self)
          end
        elsif step.status == Joaquin::STATUS_FAILED
          weak_self.status = Joaquin::STATUS_FAILED
          Print.debug("Job with id #{weak_self.job_id.magenta} finished with status #{weak_self.status.magenta}")
          Job.submit_job_update(weak_self)
          completion.call(weak_self)
        end
      end

      @first_step.run(completion)
    end

    def self.submit_job_update(job)
      # TODO: Submit update
      Print.debug("Updating remote status (#{job.status.magenta}) for job with id #{job.job_id.magenta} and job_id #{step.job_id.magenta}...")
    end

  end
end
