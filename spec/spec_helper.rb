require 'rubygems'
require 'rspec'

require File.dirname(__FILE__) + '/../lib/RightSignature2013'

RSpec.configure do |c|
  c.mock_with :rspec

  c.before(:each) do
    @rs = RightSignature2013::Connection.new({:consumer_key => "Consumer123", :consumer_secret => "Secret098", :access_token => "AccessToken098", :access_secret => "AccessSecret123", :api_token => "APITOKEN"})
  end
end
