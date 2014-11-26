require 'yaml'
require 'savon'
require 'json'

Dir[__dir__ + '/**/*.rb'].each { |f| require f }

module F5Collector

  CONF_PATH = File.join(File.dirname(__dir__), "conf")
  CONFIG = YAML.load_file(File.join CONF_PATH, "config.yml")

  def self.logger
    @@logger ||= Proc.new {
      logger = Logger.new(STDERR)
      logger.level = Logger::ERROR
      logger
    }.call
  end

end