module Delayed
  module Backend
    module Mock
      class Job
        include Delayed::Backend::Base

        @@job_count  = 0

        def self.create(params)
          @@job_count += 1
        end

        def self.count
          @@job_count
        end

        def self.reset
          @@job_count = 0
        end
      end
    end
  end
end