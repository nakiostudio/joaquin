require 'open3'

module Joaquin
  class Step

    attr_accessor :job_id, :step_id, :status, :dir_path, :file_name, :next_step

    def initialize(job_id, json)
      @job_id = job_id
      @step_id = json['step_id']
      @status = Joaquin::STATUS_UNSTARTED
      @dir_path = File.join(Joaquin.jobs_directory, @job_id)
      @file_name = "#{@step_id}.sh"

      # Write script to file
      file_path = File.join(dir_path, file_name)
      FileUtils.mkdir_p(@dir_path)
      File.open(file_path, 'wb') do |file|
        file.puts(json['script'])
      end
    end

    def run(&completion)
      weak_self = WeakRef.new(self)
      unless @status == Joaquin::STATUS_UNSTARTED
        completion.call(weak_self)
      end

      @status = Joaquin::STATUS_STARTED
      Open3.popen3("sh #{@file_name}", chdir: @dir_path) do |stdin, stdout, stderr, thread|
        Thread.new do
          stdout.each { |l| Step.submit_log(weak_self, Joaquin::LOG_TYPE_OUTPUT, l) }
        end
        Thread.new do
          stderr.each { |l| Step.submit_log(weak_self, Joaquin::LOG_TYPE_ERROR, l) }
        end
        exit_status = thread.value
        weak_self.status = exit_status == 0 ? Joaquin::STATUS_SUCCESSFUL : Joaquin::STATUS_FAILED
        Step.submit_step_update(weak_self)
        completion.call(weak_self)
      end
    end

    def self.submit_log(step, type, line)
      # TODO: Submit log
      puts "#{type}: #{line}"
    end

    def self.submit_step_update(step)
      # TODO: Submit update
    end

  end
end
