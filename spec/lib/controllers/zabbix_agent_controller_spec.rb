describe ZabbixAgentController do

  let!(:discovery_response) {
    {
      data: [
        {"{#ENDPOINT}" => "172.16.128.101", 
         "{#POOL_NAME}" => "pool_portalrh_promais_443", 
         "{#MEMBER_IP}" => "172.23.27.225",
         "{#MEMBER_PORT}" => "443"},
        {"{#ENDPOINT}" => "172.16.128.101", 
         "{#POOL_NAME}" => "pool_portalrh_promais_80", 
         "{#MEMBER_IP}" => "172.23.27.225",
         "{#MEMBER_PORT}" => "80"},
        {"{#ENDPOINT}" => "172.16.128.101", 
         "{#POOL_NAME}" => "pool_portalrh_promais_80", 
         "{#MEMBER_IP}" => "172.23.27.227",
         "{#MEMBER_PORT}" => "80"},
        {"{#ENDPOINT}" => "172.16.128.101", 
         "{#POOL_NAME}" => "pool_portalrh_promais_80", 
         "{#MEMBER_IP}" => "172.23.27.251",
         "{#MEMBER_PORT}" => "80"},
        {"{#ENDPOINT}" => "172.16.128.101", 
         "{#POOL_NAME}" => "pool_portalrh_promais_80", 
         "{#MEMBER_IP}" => "172.23.27.252",
         "{#MEMBER_PORT}" => "80"}
      ]
    }.to_json
  }

  let!(:endpoint_ips) {
    ['172.16.128.101']
  }

  let(:member) {
    {
      endpoint_ip: endpoint_ips.first, 
      pool_name: "pool_portalrh_promais_80", 
      member_ip: "172.23.27.225",
      member_port: 80
    }
  }

  context "when discovering" do
    it "should throw an error if endpoint_ips is nil" do
      expect { subject.discover nil }.to raise_error('Endpoint ip list is required!')
    end

    it "should throw an error if endpoint_ips is empty" do
      expect { subject.discover [] }.to raise_error('Endpoint ip list is required!')
    end

    context "when something gets wrong" do

      before {
        pool_service_mock = instance_double("PoolService")
        expect(pool_service_mock).to receive(:discover_pools).and_raise(Savon::Error)
        expect(PoolService).to receive(:new).and_return(pool_service_mock)
      }

      it "should log an error" do
        expect_any_instance_of(Logger).to receive(:error).with("Endpoint: #{endpoint_ips.first}").and_yield
        subject.discover endpoint_ips
      end
    end

    context "given a valid endpoint ip list" do
      it "should return all discovered pools and it's members, per endpoint ip" do
        VCR.use_cassette('pool_service', :match_requests_on => [:body]) do
          expect(subject.discover endpoint_ips).to eq(discovery_response)
        end
      end
    end
  end

  context "when getting statistics" do
    it { expect { subject.statistics nil, nil, nil, nil }.to raise_error('Endpoint ip is required!') }
    it { expect { subject.statistics endpoint_ips.first, nil, nil, nil }.to raise_error('Pool name is required!') }
    it { expect { subject.statistics endpoint_ips.first, 'pool_name', nil, nil }.to raise_error('Member ip is required!') }
    it { expect { subject.statistics endpoint_ips.first, 'pool_name', 'member_ip', nil }.to raise_error('Member port is required!') }

    it "should return member's current connections low count" do
      VCR.use_cassette('pool_member_service', :match_requests_on => [:body]) do
        expect(subject.statistics member[:endpoint_ip], member[:pool_name], member[:member_ip], member[:member_port]).to eq("0")
      end
    end

    context "when something gets wrong" do

      let(:pool_member_service_mock) { instance_double("PoolMemberService") }

      before {
        expect(pool_member_service_mock).to receive(:get_statistics).and_raise(Savon::Error)
        expect(PoolMemberService).to receive(:new).and_return(pool_member_service_mock)
        expect_any_instance_of(Logger).to receive(:error).with("Endpoint: #{endpoint_ips.first}").and_yield
      }

      it "should log an error" do
        subject.statistics member[:endpoint_ip], member[:pool_name], member[:member_ip], member[:member_port]
      end

      it "should return 'ZBX_NOTSUPPORTED'" do
        expect(subject.statistics member[:endpoint_ip], member[:pool_name], member[:member_ip], member[:member_port]).to eq('ZBX_NOTSUPPORTED')
      end
    end
  end

end