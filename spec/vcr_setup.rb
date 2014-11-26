require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { :record => :new_episodes }

  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end