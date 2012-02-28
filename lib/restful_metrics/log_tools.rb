unless defined?(Logger)
  require 'logger'
end

module RestfulMetrics

  module LogTools

    def logger(msg, level = :warn)
      msg = "#### RESTful Metrics #### " + msg
      if defined?(Rails) && defined?(Rails.logger)
        log = Rails.logger
      else
        log = Logger.new(STDOUT)
      end

      level == :warn ? log.warn(msg) : log.info(msg)
    end

  end

end
