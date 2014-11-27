class ZabbixAgentController
  def discover endpoint_ips
    raise 'Endpoint ip list is required!' unless endpoint_ips && !endpoint_ips.empty?

    response = { data: [] }

    endpoint_ips.each do |ip|
      service = PoolService.new F5Collector::CONF_PATH, ip, F5Collector::CONFIG[:pool_service]

      begin
        pools = service.discover_pools
        service.discover_pool_members(pools).each do |pool|
          pool.last.each { |member| 
            response[:data].push fill_pool_member_template(ip, pool.first, member[:address], member[:port])
          }
        end
      rescue => exception
        log ip, exception
      end
    end

    response.to_json
  end
  
  def statistics endpoint_ip, pool_name, member_ip, member_port
    raise 'Endpoint ip is required!' unless endpoint_ip
    raise 'Pool name is required!' unless pool_name
    raise 'Member ip is required!' unless member_ip
    raise 'Member port is required!' unless member_port

    service = PoolMemberService.new F5Collector::CONF_PATH, endpoint_ip, F5Collector::CONFIG[:pool_member_service]
    service.get_statistics [pool_name], member_ip, member_port, "STATISTIC_SERVER_SIDE_CURRENT_CONNECTIONS", :low
  rescue Savon::Error => exception
    log endpoint_ip, exception
    "ZBX_NOTSUPPORTED"
  end

  private
  def fill_pool_member_template endpoint_ip, pool_name, member_ip, member_port
    {"{#ENDPOINT}" => "#{endpoint_ip}",
     "{#POOL_NAME}" => "#{pool_name}", 
     "{#MEMBER_IP}" => "#{member_ip}",
     "{#MEMBER_PORT}" => "#{member_port}"}
  end

  def log endpoint_ip, exception
    F5Collector.logger.error("Endpoint: #{endpoint_ip}") {
      [exception.message,exception.backtrace].join("\n")
    }
  end
end