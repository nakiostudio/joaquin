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
        completion.call(weak_self)
      end

      # TODO: Set env variables

      @status = Joaquin::STATUS_STARTED
      completion = lambda do |step|
        if step.status == Joaquin::STATUS_SUCCESSFUL
          unless step.next_step.nil?
            step.next_step.run(completion)
          else
            weak_self.status = Joaquin::STATUS_SUCCESSFUL
            Job.submit_job_update(weak_self)
            completion.call(weak_self)
          end
        else if step.status == Joaquin::STATUS_FAILED
          weak_self.status = Joaquin::STATUS_FAILED
          Job.submit_job_update(weak_self)
          completion.call(weak_self)
        end
      end

      @first_step.run(completion)
    end

    def self.submit_job_update(job)
      # TODO: Submit update
    end

  end
end
