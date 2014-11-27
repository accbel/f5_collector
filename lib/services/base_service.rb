class BaseService
  def initialize path, endpoint_ip, config
    @client = Savon.client do |s|
      s.wsdl File.expand_path(File.join path, config[:wsdl])
      s.basic_auth [config[:user], config[:password]]
      s.ssl_verify_mode :none
      s.endpoint (config[:endpoint] % endpoint_ip)
      s.namespace config[:namespace]
      s.env_namespace :soapenv
      s.namespace_identifier config[:namespace_identifier]
      s.open_timeout config[:open_timeout]
      s.read_timeout config[:read_timeout]
    end
  end

  def operations
    @client.operations
  end

  def globals
    @client.globals
  end
end