class SimpleLogger
  ERROR = 1
  WARNING = 2
  INFO = 3
  @@log = File.open("class_based_singleton_test.txt", "w")
  @@level = WARNING

  def self.level=(new_level)
    @@level = new_level
  end

  def self.level
    @@level
  end

  def self.error(msg)
    @@log.puts("Error: #{msg}")
    @@log.flush
  end

  def self.warning(msg)
    @@log.puts("Warning: #{msg}") if @@level >= WARNING
    @@log.flush
  end

  def self.info(msg)
    @@log.puts("Info: #{msg}") if @@level >= INFO
    @@log.flush
  end
end

logger = SimpleLogger
logger.level = SimpleLogger::WARNING
logger.warning('Alert message')
logger.info('Insufficient level access. I should not be able to log this.')
logger.error('I should have access to log an error')

SimpleLogger.level = SimpleLogger::INFO
logger.info('meh')
logger.info('baz')
