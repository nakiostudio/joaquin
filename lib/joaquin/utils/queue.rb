module Joaquin
  class Queue

    attr_accessor :jobs, :concurrent_jobs

    def initialize(concurrent_jobs)
      @jobs = {}
      @concurrent_jobs = concurrent_jobs
    end

  end
end
