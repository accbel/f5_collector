class PoolMemberService < BaseService
  def get_statistics pools, member_ip, member_port, statistics_type, statistics_value
    message = { 
      "pool_names" => { "item" => pools },
      "members" => [{
        "items" => [{
          "item" => { "address" => member_ip, "port" => member_port }
        }]
      }]
    }
    response = @client.call(:get_statistics, message: message).body
    response[:get_statistics_response][:return][:item][:statistics][:item][:statistics][:item].select { |e| e[:type] == statistics_type }.first[:value][statistics_value]
  end
end