class SimpleLogger

  attr_writer :level
  @@instance = SimpleLogger.new

  ERROR = 1
  WARNING = 2
  INFO = 3

  def log
    @log ||= File.open("log.txt", "w")
  end

  def level
    @level ||= WARNING
  end

  def error(msg)
    log.puts("Error: #{msg}")
    log.flush
  end

  def warning(msg)
    log.puts("Warning: #{msg}") if level >= WARNING
    log.flush
  end

  def info(msg)
    log.puts("Info: #{msg}") if level >= INFO
    log.flush
  end

  def self.instance
    return @@instance
  end

  private_class_method :new
end

warn_logger = SimpleLogger.instance
warn_logger.level = SimpleLogger::WARNING
warn_logger.warning('W A R N I N G ! !')
warn_logger.info('Insufficient level access. I should not be able to log this.')
warn_logger.error('I should have access to log an error')

logger = SimpleLogger.instance
logger.level = SimpleLogger::INFO
logger.info('foo 1')
logger.info('bar 2')

puts "Have loggers the same object_id? #{logger.object_id == warn_logger.object_id}"
