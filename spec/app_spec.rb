ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

module Helpers
  def app
    Sinatra::Application
  end

  def response_data
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Helpers
end

describe 'GET /groups' do
  it "it returns an array of groups" do
    get '/groups'
    expect(response_data).to be_a(Array)
  end
end
