require 'fakeweb'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.stub_with :fakeweb
  c.ignore_localhost = true
end
