require 'open3'

module Joaquin
  class Step

    attr_accessor :job_id, :step_id, :status, :dir_path, :file_name, :next_step

    def initialize(job_id, json)
      @job_id = job_id
      @step_id = json['step_id']
      @status = Joaquin::STATUS_UNSTARTED
      @dir_path = File.join(Joaquin.options.jobs_directory, @job_id)
      @file_name = "#{@step_id}.sh"

      # Write script to file
      file_path = File.join(@dir_path, @file_name)
      Print.debug("Writing step script at path #{file_path}")
      FileUtils.mkdir_p(@dir_path)
      File.open(file_path, 'wb') do |file|
        file.puts(json['script'])
      end
    end

    def run(completion)
      weak_self = WeakRef.new(self)

      # Skip running if step has already been started
      unless @status == Joaquin::STATUS_UNSTARTED
        Print.error("Trying to rerun started step with id #{@step_id.magenta} and job_id #{@job_id.magenta}")
        completion.call(weak_self)
      end

      # Run script
      @status = Joaquin::STATUS_STARTED
      Print.debug("Running step with id #{@step_id.magenta} and job_id #{@job_id.magenta}...")
      Open3.popen3("sh #{@file_name}", chdir: @dir_path) do |stdin, stdout, stderr, thread|
        # Process script standard output
        Thread.new do
          stdout.each { |l| Step.submit_step_log(weak_self, Joaquin::LOG_TYPE_OUTPUT, l) }
        end

        # Process script standard error
        Thread.new do
          stderr.each { |l| Step.submit_step_log(weak_self, Joaquin::LOG_TYPE_ERROR, l) }
        end

        # Wait for thread to finish
        exit_status = thread.value.exitstatus

        # Notify result
        Print.debug("Step with id #{weak_self.step_id.magenta} and job_id #{weak_self.job_id.magenta} finished with status #{exit_status}")
        weak_self.status = exit_status == 0 ? Joaquin::STATUS_SUCCESSFUL : Joaquin::STATUS_FAILED
        Step.submit_step_update(weak_self)
        completion.call(weak_self)
      end
    end

    def self.submit_step_log(step, type, line)
      Print.debug("Updating log line with type #{type.magenta} for step with id #{step.step_id.magenta} and job_id #{step.job_id.magenta}...")
      Api.shared.submit_step_log(step, type, line)
    end

    def self.submit_step_update(step)
      Print.debug("Updating remote status (#{step.status.magenta}) for step with id #{step.step_id.magenta} and job_id #{step.job_id.magenta}...")
      Api.shared.submit_step_update(step)
    end

  end
end
