require 'yaml'
require 'savon'
require 'json'

require 'f5_collector/version'
require 'services/base_service'
require 'services/pool_service'
require 'services/pool_member_service'
require 'controllers/zabbix_agent_controller'

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