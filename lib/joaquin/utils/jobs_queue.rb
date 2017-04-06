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
      # Kill loop thread
      Thread.kill(@loop_thread)

      # Gather all jobs that have been started
      started_jobs = []
      @@lock.synchronize do
        started_jobs = @running_jobs.map { |running_job| running_job.job }
      end

      # Cancel each started job independently
      started_jobs.each do |started_job|
        cancel_job_with_id(started_job.job_id)
      end
    end

    def add_job(job)
      # Add job to queue
      @@lock.synchronize do
        @queued_jobs << job
      end
    end

    def cancel_job_with_id(id)
      @@lock.synchronize do
        # Skip if there isn't a running job with such id
        return if @running_jobs[id].nil?

        # Otherwise cancel
        running_job = @running_jobs[id]
        Thread.kill(running_job.thread)
        running_job.job.cancel()

        # Remove job from jobs dict
        running_jobs.delete(id)
      end
    end

    private

    def dequeue_job
      @@lock.synchronize do
        # Skip if there are no items queued o running queue is already full
        return if @queued_jobs.first.nil? || @running_jobs.keys.count == @concurrent_jobs

        # Dequeue first job, create and store running job
        job = @queued_jobs.first
        running_job = RunningJob.new(job)
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

    def common_job_completion
      weak_self = WeakRef.new(self)
      completion = lambda do |job|
        weak_self.complete_job(job)
      end
      return completion
    end

    def complete_job(job)
      @@lock.synchronize do
        # Skip if running job with the given id cannot be found
        return if @running_jobs[job.job_id].nil?

        # Remove from running jobs dict
        @running_jobs.delete(job.job_id)
      end
    end

  end
end
