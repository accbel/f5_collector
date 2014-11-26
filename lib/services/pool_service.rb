class PoolService < BaseService
  def discover_pools
    @client.call(:get_list).body[:get_list_response][:return][:item]
  end

  def discover_pool_members pool_names
    response = @client.call(:get_member, message: { "pool_names" => { "item" => pool_names } }).body
    pool_names.zip(response[:get_member_response][:return][:item].map { |i| i[:item] })
  end
end