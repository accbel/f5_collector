describe 'PoolMemberService' do

  let(:endpoint_ip) { '172.16.128.101' }
  let(:pools) { ['pool_portalrh_promais_80'] }
  let(:member_ip) { '172.23.27.225' }
  let(:member_port) { 80 }
  let(:statistics_type) { "STATISTIC_SERVER_SIDE_CURRENT_CONNECTIONS" }
  let(:statistics_key) { :low }

  subject {
    PoolMemberService.new F5Collector::CONF_PATH, endpoint_ip, F5Collector::CONFIG[:pool_member_service]
  }

  it "should get statistics per member" do
    VCR.use_cassette('pool_member_service', :match_requests_on => [:body]) do
      value = subject.get_statistics pools, member_ip, member_port, statistics_type, statistics_key
      expect(value).to eq("0")
    end
  end

  it "should fail to get statistics from an unknown member" do
    VCR.use_cassette('pool_member_service', :match_requests_on => [:body]) do
      wrong_member_ip = '172.23.27.230'
      expect {
        subject.get_statistics pools, wrong_member_ip, member_port, statistics_type, statistics_key
      }.to raise_error(Savon::Error)
    end
  end

end