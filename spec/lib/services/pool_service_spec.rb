describe "PoolService" do

  subject {
    PoolService.new F5Collector::CONF_PATH, endpoint_ip, F5Collector::CONFIG[:pool_service]
  }

  let!(:pools) {
    [
     "pool_portalrh_promais_443",
     "pool_portalrh_promais_80"
    ]
  }

  let(:endpoint_ip) { '172.16.128.101' }

  let(:members) {
    [
      [pools.first,
        [{:address=>"172.23.27.225", :port=>"443"}] ],
      [pools.last,
        [{:address=>"172.23.27.225", :port=>"80"},
         {:address=>"172.23.27.227", :port=>"80"},
         {:address=>"172.23.27.251", :port=>"80"},
         {:address=>"172.23.27.252", :port=>"80"}] ] 
    ]
  }

  it "should get all pools" do
    VCR.use_cassette('pool_service', :match_requests_on => [:body]) do
      expect(subject.discover_pools).to eq(pools)
    end
  end

  it "should get all members per pool" do
    VCR.use_cassette('pool_service', :match_requests_on => [:body]) do
      expect(subject.discover_pool_members pools).to eq(members)
    end
  end  

end