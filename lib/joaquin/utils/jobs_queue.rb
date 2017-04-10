module Joaquin
  class RunningJob

    attr_accessor :job, :thread

    def initialize(job)
      @job = job
    end

  end

  class JobsQueue

    attr_accessor :queued_jobs, :running_jobs, :concurrent_jobs, :loop_thread, :cancelled

    def initialize(concurrent_jobs)
      @queued_jobs = []
      @running_jobs = {}
      @concurrent_jobs = concurrent_jobs
      @cancelled = false
      @lock = Mutex.new
    end

    def resume
      Print.debug('Initializing jobs queue loop')

      weak_self = WeakRef.new(self)
      @loop_thread = Thread.new do
        while weak_self.cancelled == false do
          weak_self.dequeue_job()
          sleep(5)
        end
      end
    end

    def cancel(&completion)
      Print.debug('Killing jobs queue loop...')

      # Change loop thread
      @cancelled = true
      @loop_thread.join
      @loop_thread = nil
      Print.debug('Jobs queue loop has been terminated')

      # Gather all jobs that have been started
      started_jobs = @running_jobs.map do |running_job|
        return running_job.job
      end

      # Cancel each started job independently
      started_jobs.each do |started_job|
        cancel_job_with_id(started_job.job_id)
      end

      # Notify
      completion.call()
    end

    def is_running?
      return !(@loop_thread.nil?)
    end

    def add_job(job)
      Print.debug("Adding job to queue with job id #{job.job_id.magenta}")

      # Add job to queue
      @lock.synchronize do
        @queued_jobs << job
      end
    end

    def cancel_job_with_id(id)
      Print.debug("Cancelling job with job id #{job.job_id.magenta}")

      @lock.synchronize do
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

    def dequeue_job
      job = nil
      running_job = nil
      continue = true

      # Skip if there are no items queued o running queue is already full
      @lock.synchronize do
        continue = !(@queued_jobs.first.nil? || @running_jobs.keys.count == @concurrent_jobs)
      end
      return unless continue

      @lock.synchronize do
        Print.debug('Job found, dequeueing...')

        # Dequeue first job, create and store running job
        job = @queued_jobs.first
        running_job = RunningJob.new(job)
        @running_jobs[job.job_id] = running_job

        # Remove from queued jobs
        @queued_jobs.shift
      end

      # Run job in a different thread
      weak_self = WeakRef.new(self)
      running_job.thread = Thread.new do
        Print.debug("Running job with id #{job.job_id.magenta}")
        job.run do |weak_job|
          weak_self.complete_job(weak_job)
        end
      end
    end

    def complete_job(job)
      @lock.synchronize do
        # Skip if running job with the given id cannot be found
        return if @running_jobs[job.job_id].nil?

        # Remove from running jobs dict
        @running_jobs.delete(job.job_id)
      end
    end

  end
end
