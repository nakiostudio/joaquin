module Joaquin
  class RunningJob

    attr_accessor :job, :thread

    def initialize(job)
      @job = job
    end

  end

  class JobsQueue

    @@lock = Mutex.new

    attr_accessor :queued_jobs, :running_jobs, :concurrent_jobs, :loop_thread

    def initialize(concurrent_jobs)
      @queued_jobs = []
      @running_jobs = {}
      @concurrent_jobs = concurrent_jobs
    end

    def resume
      weak_self = WeakRef.new(self)
      @loop_thread = Thread.new do
        loop do
          weak_self.deque_job()
          sleep(5)
        end
      end
    end

    def cancel
      Thread.kill(@loop_thread)
    end

    def add_job(job)
      @@lock.synchronize do
        @queued_jobs << job
      end
    end

    def cancel_job_with_id(id)

    end

    private

    def dequeue_job
      @@lock.synchronize do
        # Skip if there are no items queued o running queue is already full
        return if @queued_jobs.first.nil? || @running_jobs.keys.count == @concurrent_jobs

        # Dequeue first job, create and store running job
        job = @queued_jobs.first
        running_job = RunningJob.next(job)
        @running_jobs[job.job_id] = running_job

        # Run job in a different thread
        weak_self = WeakRef.new(self)
        running_job.thread = Thread.new do
          job.run(weak_self.common_job_completion)
        end

        # Remove from queued jobs
        @queued_jobs.shift
      end
    end

    def common_job_completion do
      weak_self = WeakRef.new(self)
      completion = lambda do |job|

      end
      return completion
    end

  end
end
